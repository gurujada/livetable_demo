defmodule DemoWeb.FlagshipLive do
  @moduledoc """
  Demo 10: Flagship - All Features
  Demonstrates: everything combined with CSV export (100,000 rows).
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource

  import Ecto.Query
  alias DemoWeb.Layouts
  alias LiveTable.{Boolean, Select, Range}
  import DemoWeb.Helpers, only: [format_currency: 1]

  def mount(_params, _session, socket) do
    socket = assign(socket, :data_provider, {__MODULE__, :base_query, []})
    {:ok, socket}
  end

  def base_query do
    from p in Demo.Flagship.Product,
      join: b in assoc(p, :brand),
      as: :brand,
      join: c in assoc(p, :category),
      as: :category,
      join: w in assoc(p, :warehouse),
      as: :warehouse,
      select: %{
        id: p.id,
        sku: p.sku,
        name: p.name,
        description: p.description,
        price: p.price,
        cost: p.cost,
        profit_margin: (p.price - p.cost) / p.cost * 100,
        stock_quantity: p.stock_quantity,
        status: p.status,
        is_featured: p.is_featured,
        rating: p.rating,
        brand_name: b.name,
        brand_country: b.country,
        category_name: c.name,
        warehouse_name: w.name,
        warehouse_city: w.city,
        warehouse_region: w.region
      }
  end

  def fields do
    [
      id: %{label: "ID", sortable: true},
      sku: %{label: "SKU", searchable: true},
      name: %{label: "Product", sortable: true, searchable: true},
      brand_name: %{label: "Brand", sortable: true, searchable: true, assoc: {:brand, :name}},
      category_name: %{
        label: "Category",
        sortable: true,
        searchable: true,
        assoc: {:category, :name}
      },
      price: %{label: "Price", sortable: true, renderer: &format_price/1},
      cost: %{label: "Cost", renderer: &format_cost/1},
      profit_margin: %{label: "Margin", renderer: &render_margin/1},
      stock_quantity: %{label: "Stock", sortable: true, renderer: &render_stock/1},
      status: %{label: "Status", renderer: &render_status/1},
      rating: %{label: "Rating", renderer: &render_rating/1},
      warehouse_region: %{label: "Region", assoc: {:warehouse, :region}}
    ]
  end

  def filters do
    [
      category:
        Select.new({:category, :name}, "category", %{
          label: "Category",
          mode: :tags,
          options_source: {Demo.Flagship, :search_categories, []}
        }),
      price_range:
        Range.new(:price, "price_range", %{
          label: "Price Range",
          unit: "₹",
          min: 100,
          max: 100_000,
          step: 1000,
          default_min: 100,
          default_max: 100_000,
          pips: true
        }),
      featured:
        Boolean.new(:is_featured, "featured", %{
          label: "Featured Only",
          condition: dynamic([p], p.is_featured == true)
        }),
      in_stock:
        Boolean.new(:stock_quantity, "in_stock", %{
          label: "In Stock Only",
          condition: dynamic([p], p.stock_quantity > 0)
        }),
      high_rated:
        Boolean.new(:rating, "high_rated", %{
          label: "High Rated (4+)",
          condition: dynamic([p], p.rating >= 4.0)
        })
    ]
  end

  def actions do
    %{
      label: "Actions",
      items: [
        view: &view_action/1,
        edit: &edit_action/1
      ]
    }
  end

  defp view_action(assigns) do
    ~H"""
    <button
      phx-click="view_product"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-eye" class="size-4" /> View Details
    </button>
    """
  end

  defp edit_action(assigns) do
    ~H"""
    <button
      phx-click="edit_product"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-pencil" class="size-4" /> Edit Product
    </button>
    """
  end

  def table_options do
    %{
      pagination: %{
        sizes: [25, 50],
        default_size: 50
      },
      sorting: %{
        default_sort: [inserted_at: :desc]
      },
      search: %{
        placeholder: "Search 100K products..."
      },
      exports: %{
        enabled: true,
        formats: [:csv]
      },
      fixed_header: true
    }
  end

  def handle_event("view_product", %{"id" => _id}, socket) do
    {:noreply,
     put_flash(socket, :info, "In a real app, this would navigate to the product detail page")}
  end

  def handle_event("edit_product", %{"id" => _id}, socket) do
    {:noreply, put_flash(socket, :info, "In a real app, this would open the product edit form")}
  end

  defp format_price(price) do
    formatted = format_currency(price)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono font-medium text-green-700 dark:text-green-400">₹{@formatted}</span>
    """
  end

  defp format_cost(cost) do
    formatted = format_currency(cost)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono text-muted-foreground">₹{@formatted}</span>
    """
  end

  defp render_margin(margin) do
    margin_float = Decimal.to_float(margin)

    color =
      cond do
        margin_float >= 40 -> "text-green-600 dark:text-green-400"
        margin_float >= 20 -> "text-yellow-600 dark:text-yellow-400"
        true -> "text-red-600 dark:text-red-400"
      end

    assigns = %{margin: margin_float, color: color}

    ~H"""
    <span class={["font-mono", @color]}>{:erlang.float_to_binary(@margin, decimals: 1)}%</span>
    """
  end

  defp render_stock(quantity) do
    {bg, text} =
      cond do
        quantity == 0 ->
          {"bg-red-100 dark:bg-red-900/30", "text-red-700 dark:text-red-400"}

        quantity < 50 ->
          {"bg-yellow-100 dark:bg-yellow-900/30", "text-yellow-700 dark:text-yellow-400"}

        true ->
          {"bg-green-100 dark:bg-green-900/30", "text-green-700 dark:text-green-400"}
      end

    assigns = %{quantity: quantity, bg: bg, text: text}

    ~H"""
    <span class={["px-2 py-1 text-xs rounded-full font-mono", @bg, @text]}>
      {@quantity}
    </span>
    """
  end

  defp render_status(status) do
    {bg, text} =
      case status do
        "active" -> {"bg-green-100 dark:bg-green-900/30", "text-green-700 dark:text-green-400"}
        "draft" -> {"bg-gray-100 dark:bg-gray-800", "text-gray-700 dark:text-gray-400"}
        "discontinued" -> {"bg-red-100 dark:bg-red-900/30", "text-red-700 dark:text-red-400"}
        _ -> {"bg-gray-100 dark:bg-gray-800", "text-gray-700 dark:text-gray-400"}
      end

    assigns = %{status: status, bg: bg, text: text}

    ~H"""
    <span class={["px-2 py-1 text-xs rounded-full capitalize", @bg, @text]}>
      {@status}
    </span>
    """
  end

  defp render_rating(nil) do
    assigns = %{}

    ~H"""
    <span class="text-muted-foreground">-</span>
    """
  end

  defp render_rating(rating) do
    rating_float = Decimal.to_float(rating)

    color =
      cond do
        rating_float >= 4.0 -> "text-green-600 dark:text-green-400"
        rating_float >= 3.0 -> "text-yellow-600 dark:text-yellow-400"
        true -> "text-red-600 dark:text-red-400"
      end

    assigns = %{rating: rating_float, color: color}

    ~H"""
    <div class="flex items-center gap-1">
      <span class={["font-medium", @color]}>
        {:erlang.float_to_binary(@rating, decimals: 1)}
      </span>
      <span class="text-yellow-500">★</span>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={10}
          title="Flagship"
          rows="100K rows"
          description="All features combined - joins, filters, actions, CSV export, and scale. The ultimate LiveTable demo."
          featured={true}
        />

        <.live_table
          fields={fields()}
          filters={filters()}
          actions={actions()}
          options={@options}
          streams={@streams}
        />
      </div>
    </Layouts.app>
    """
  end
end
