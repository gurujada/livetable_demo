defmodule DemoWeb.InventoryLive do
  @moduledoc """
  Demo 7: Computed Fields - Inventory Stock Items
  Demonstrates: computed fields like profit margin, stock value (10,000 rows).
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
    from s in Demo.Inventory.StockItem,
      join: w in assoc(s, :warehouse),
      as: :warehouse,
      join: sup in assoc(s, :supplier),
      as: :supplier,
      select: %{
        id: s.id,
        sku: s.sku,
        name: s.name,
        quantity: s.quantity,
        reorder_level: s.reorder_level,
        unit_cost: s.unit_cost,
        selling_price: s.selling_price,
        stock_value: s.quantity * s.unit_cost,
        potential_revenue: s.quantity * s.selling_price,
        profit_margin: (s.selling_price - s.unit_cost) / s.unit_cost * 100,
        needs_reorder: s.quantity <= s.reorder_level,
        warehouse_name: w.name,
        warehouse_region: w.region,
        supplier_name: sup.name,
        supplier_rating: sup.rating,
        last_restocked: s.last_restocked
      }
  end

  def fields do
    [
      id: %{label: "ID", hidden: true},
      sku: %{label: "SKU", searchable: true},
      name: %{label: "Product", sortable: true, searchable: true},
      quantity: %{label: "Qty", sortable: true, renderer: &render_quantity/2},
      unit_cost: %{label: "Cost", renderer: &format_cost/1},
      selling_price: %{label: "Price", sortable: true, renderer: &format_price/1},
      profit_margin: %{label: "Margin", renderer: &render_margin/1},
      stock_value: %{label: "Stock Value", renderer: &format_stock_value/1},
      warehouse_name: %{label: "Warehouse", sortable: true, assoc: {:warehouse, :name}},
      warehouse_region: %{label: "Region", assoc: {:warehouse, :region}},
      supplier_name: %{
        label: "Supplier",
        searchable: true,
        assoc: {:supplier, :name}
      }
    ]
  end

  def filters do
    [
      region:
        Select.new({:warehouse, :region}, "region", %{
          label: "Region",
          mode: :tags,
          options_source: {Demo.Inventory, :search_warehouses_by_region, []}
        }),
      quantity_range:
        Range.new(:quantity, "quantity_range", %{
          type: :number,
          label: "Quantity",
          min: 0,
          max: 1000,
          step: 50,
          pips: true
        }),
      price_range:
        Range.new(:selling_price, "price_range", %{
          type: :number,
          label: "Selling Price",
          unit: "₹",
          min: 100,
          max: 10000,
          step: 100,
          pips: true
        }),
      low_stock:
        Boolean.new(:quantity, "low_stock", %{
          label: "Low Stock Alert",
          condition: dynamic([s], s.quantity <= s.reorder_level)
        }),
      out_of_stock:
        Boolean.new(:quantity, "out_of_stock", %{
          label: "Out of Stock",
          condition: dynamic([s], s.quantity == 0)
        }),
      high_margin:
        Boolean.new(:selling_price, "high_margin", %{
          label: "High Margin (30%+)",
          condition: dynamic([s], (s.selling_price - s.unit_cost) / s.unit_cost >= 0.3)
        })
    ]
  end

  def actions do
    %{
      label: "Actions",
      items: [
        view: &view_action/1,
        reorder: &reorder_action/1
      ]
    }
  end

  defp view_action(assigns) do
    ~H"""
    <button
      phx-click="view_item"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-eye" class="size-4" /> View Details
    </button>
    """
  end

  defp reorder_action(assigns) do
    ~H"""
    <button
      phx-click="reorder_item"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-package-plus" class="size-4" /> Reorder Stock
    </button>
    """
  end

  def table_options do
    %{
      pagination: %{sizes: [10, 25, 50, 100], default_size: 25},
      sorting: %{default_sort: [name: :asc]},
      search: %{placeholder: "Search inventory..."}
    }
  end

  def handle_event("view_item", %{"id" => _id}, socket) do
    {:noreply,
     put_flash(socket, :info, "In a real app, this would navigate to the stock item detail page")}
  end

  def handle_event("reorder_item", %{"id" => _id}, socket) do
    {:noreply, put_flash(socket, :info, "In a real app, this would open the reorder form")}
  end

  defp format_cost(amount) do
    formatted = format_currency(amount)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono text-muted-foreground">₹{@formatted}</span>
    """
  end

  defp format_price(amount) do
    formatted = format_currency(amount)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono">₹{@formatted}</span>
    """
  end

  defp format_stock_value(amount) do
    formatted = format_currency(amount)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono font-medium text-green-700 dark:text-green-400">₹{@formatted}</span>
    """
  end

  defp render_quantity(quantity, record) do
    needs_reorder = record.needs_reorder
    assigns = %{quantity: quantity, needs_reorder: needs_reorder}

    ~H"""
    <div class="flex items-center gap-2">
      <span class={if @needs_reorder, do: "text-red-600 dark:text-red-400 font-medium", else: ""}>
        {@quantity}
      </span>
      <span
        :if={@needs_reorder}
        class="px-1.5 py-0.5 text-xs bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400 rounded"
      >
        Low
      </span>
    </div>
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

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={7}
          title="Inventory"
          rows="10K rows"
          description="Computed fields - profit margin, stock value, and reorder alerts calculated from base data."
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
