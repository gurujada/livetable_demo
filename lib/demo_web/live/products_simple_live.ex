defmodule DemoWeb.ProductsSimpleLive do
  @moduledoc """
  Demo 4: Select Filters - Products Simple
  Demonstrates: select filters with static options (3,000 rows).

  TODO: Category and Brand are currently plain string fields. 
  Select filters require proper relationships (many-to-many) to work correctly.
  See database_tasks.md for the required schema changes.
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.ProductsSimple.Product

  alias DemoWeb.Layouts
  alias LiveTable.{Boolean, Range}
  import DemoWeb.Helpers, only: [format_currency: 1]

  def fields do
    [
      sku: %{label: "SKU", sortable: false},
      name: %{label: "Product Name", sortable: true, searchable: true},
      category: %{label: "Category", sortable: true, searchable: true},
      brand: %{label: "Brand", searchable: true, sortable: false},
      price: %{label: "Price", sortable: true, renderer: &format_price/1},
      rating: %{label: "Rating", renderer: &render_rating/1, sortable: false},
      in_stock: %{label: "In Stock", renderer: &render_stock/1, sortable: false}
    ]
  end

  # TODO: Add Select filters for Category and Brand once many-to-many relationships are set up
  # See database_tasks.md for details
  def filters do
    [
      price_range:
        Range.new(:price, "price_range", %{
          type: :number,
          label: "Price Range",
          unit: "₹",
          min: 500,
          max: 50_000,
          step: 500,
          pips: true
        }),
      in_stock:
        Boolean.new(:in_stock, "in_stock", %{
          label: "In Stock Only",
          condition: dynamic([p], p.in_stock == true)
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
        view: &view_action/1
      ]
    }
  end

  defp view_action(assigns) do
    ~H"""
    <button
      phx-click="view_product"
      phx-value-id={@record.sku}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-eye" class="size-4" /> View Details
    </button>
    """
  end

  # TODO: These will be used once Category and Brand tables are created
  # defp get_category_options do
  #   ~w(Electronics Clothing Footwear Home\ &\ Kitchen Beauty Sports Books Toys Automotive Health Grocery Jewelry Furniture Office Garden)
  #   |> Enum.map(&%{label: &1, value: [&1]})
  # end
  #
  # defp get_brand_options do
  #   ~w(Samsung Apple OnePlus Xiaomi Sony Nike Adidas Puma Boat JBL Tanishq Titan)
  #   |> Enum.map(&%{label: &1, value: [&1]})
  # end

  def table_options do
    %{
      pagination: %{
        enabled: true,
        sizes: [10, 25, 50],
        default_size: 25
      },
      sorting: %{
        enabled: true,
        default_sort: [name: :asc]
      },
      search: %{
        enabled: true,
        debounce: 300,
        placeholder: "Search products..."
      },
      fixed_header: true
    }
  end

  def handle_event("view_product", %{"id" => _id}, socket) do
    {:noreply,
     put_flash(socket, :info, "In a real app, this would navigate to the product detail page")}
  end

  defp format_price(price) do
    formatted = format_currency(price)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono text-green-700 dark:text-green-400">₹{@formatted}</span>
    """
  end

  defp render_rating(rating) when is_nil(rating) do
    assigns = %{}
    ~H[<span class="text-muted-foreground">N/A</span>]
  end

  defp render_rating(rating) do
    rating_float = Decimal.to_float(rating)
    assigns = %{rating: rating_float}

    ~H"""
    <div class="flex items-center gap-1">
      <span class={[
        "font-medium",
        cond do
          @rating >= 4.0 -> "text-green-600 dark:text-green-400"
          @rating >= 3.0 -> "text-yellow-600 dark:text-yellow-400"
          true -> "text-red-600 dark:text-red-400"
        end
      ]}>
        {:erlang.float_to_binary(@rating, decimals: 1)}
      </span>
      <span class="text-yellow-500">★</span>
    </div>
    """
  end

  defp render_stock(in_stock) do
    assigns = %{in_stock: in_stock}

    ~H"""
    <span class={[
      "px-2 py-1 text-xs rounded-full",
      if(@in_stock,
        do: "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400",
        else: "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400"
      )
    ]}>
      {if @in_stock, do: "In Stock", else: "Out of Stock"}
    </span>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={4}
          title="Products"
          rows="3K rows"
          description="Select filters with tags and quick_tags modes. Filter by category, brand, price range, and more."
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
