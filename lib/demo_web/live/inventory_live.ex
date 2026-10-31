defmodule DemoWeb.InventoryLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource

  alias LiveTable.{Boolean, Range, Select}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :data_provider, {__MODULE__, :stock, []})}
  end

  # Joined tables and computed columns, in one query. LiveTable sorts, searches and filters it.
  def stock do
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
        unit_cost: s.unit_cost,
        selling_price: s.selling_price,
        margin: (s.selling_price - s.unit_cost) / s.unit_cost * 100,
        stock_value: s.quantity * s.unit_cost,
        low: s.quantity <= s.reorder_level,
        warehouse: w.name,
        region: w.region,
        supplier: sup.name,
        supplier_rating: sup.rating
      }
  end

  def fields do
    [
      id: %{label: "ID", hidden: true},
      name: %{label: "Item", sortable: true, searchable: true, renderer: &item/2},
      quantity: %{label: "In stock", sortable: true, renderer: &quantity/2},
      unit_cost: %{label: "Cost", renderer: &cost/1},
      selling_price: %{label: "Price", sortable: true, renderer: &money/1},
      margin: %{label: "Margin", renderer: &margin/1},
      stock_value: %{label: "Stock value", renderer: &money/1},
      warehouse: %{
        label: "Warehouse",
        sortable: true,
        assoc: {:warehouse, :name},
        renderer: &warehouse/2
      },
      supplier: %{
        label: "Supplier",
        searchable: true,
        assoc: {:supplier, :name},
        renderer: &supplier/2
      },
      sku: %{label: "SKU", searchable: true, hidden: true},
      region: %{label: "Region", hidden: true, assoc: {:warehouse, :region}},
      supplier_rating: %{label: "Supplier rating", hidden: true}
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
      quantity:
        Range.new(:quantity, "quantity", %{
          label: "Quantity",
          min: 0,
          max: 1000,
          step: 50,
          pips: true,
          pips_mode: "values",
          pips_values: [0, 250, 500, 750, 1000]
        }),
      low:
        Boolean.new(:quantity, "low", %{
          label: "Needs reorder",
          condition: dynamic([s], s.quantity <= s.reorder_level)
        }),
      high_margin:
        Boolean.new(:selling_price, "high_margin", %{
          label: "Margin over 30%",
          condition: dynamic([s], (s.selling_price - s.unit_cost) / s.unit_cost >= 0.3)
        })
    ]
  end

  defp item(name, item) do
    assigns = %{name: name, sku: item.sku}

    ~H"""
    <.stacked main={@name} sub={@sku} mono />
    """
  end

  defp warehouse(name, item) do
    assigns = %{name: name, region: item.region}

    ~H"""
    <.stacked main={@name} sub={"#{@region} region"} />
    """
  end

  defp supplier(name, item) do
    assigns = %{name: name, rating: item.supplier_rating}

    ~H"""
    <div>
      <div class="font-medium">{@name}</div>
      <div class="text-xs">{rating(@rating)}</div>
    </div>
    """
  end

  def table_options do
    %{
      pagination: %{sizes: [10, 25, 50], default_size: 25},
      sorting: %{default_sort: [name: :asc]},
      search: %{placeholder: "Search item, SKU or supplier"},
      exports: %{enabled: false},
      fixed_header: true
    }
  end

  defp quantity(quantity, item) do
    assigns = %{quantity: quantity, low: item.low}

    ~H"""
    <div class="flex items-center gap-2">
      <.meter
        value={@quantity}
        max={1000}
        color={if @low, do: "bg-red-500", else: "bg-green-500"}
        label={@quantity}
      />
      <span
        :if={@low}
        class="px-1.5 py-0.5 text-xs bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400 rounded"
      >
        Low
      </span>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <Layouts.demo
        path="/inventory"
        title="Inventory"
        rows="10K rows"
        source={__source__()}
        try="Sort by warehouse, then search a supplier's name."
      >
        <:intro>
          Columns from three joined tables, plus margin and stock value computed in SQL. Sort and
          search work across all of them.
        </:intro>
        <.live_table fields={fields()} filters={filters()} options={@options} streams={@streams} />
      </Layouts.demo>
    </Layouts.app>
    """
  end
end
