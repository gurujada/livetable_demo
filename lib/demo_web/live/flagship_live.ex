defmodule DemoWeb.FlagshipLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource

  alias LiveTable.{Boolean, Range, Select}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :data_provider, {__MODULE__, :products, []})}
  end

  def products do
    from p in Demo.Flagship.Product,
      join: b in assoc(p, :brand),
      as: :brand,
      join: c in assoc(p, :category),
      as: :category,
      select: %{
        id: p.id,
        sku: p.sku,
        name: p.name,
        price: p.price,
        cost: p.cost,
        margin: fragment("round(?, 1)", (p.price - p.cost) / p.cost * 100),
        stock_quantity: p.stock_quantity,
        status: p.status,
        rating: p.rating,
        brand: b.name,
        category: c.name
      }
  end

  def fields do
    [
      id: %{label: "ID", sortable: true, renderer: &id/1},
      name: %{label: "Product", sortable: true, searchable: true, renderer: &product/2},
      brand: %{
        label: "Brand",
        sortable: true,
        searchable: true,
        assoc: {:brand, :name},
        renderer: &brand/2
      },
      price: %{label: "Price", sortable: true, renderer: &money/1},
      cost: %{label: "Cost", renderer: &cost/1},
      margin: %{label: "Margin", renderer: &margin/1},
      stock_quantity: %{label: "Stock", sortable: true, renderer: &stock/1},
      status: %{label: "Status", renderer: &status/1},
      rating: %{label: "Rating", sortable: true, renderer: &rating/1},
      sku: %{label: "SKU", searchable: true, hidden: true},
      category: %{label: "Category", sortable: true, assoc: {:category, :name}, hidden: true}
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
      price:
        Range.new(:price, "price", %{
          label: "Price",
          unit: "₹",
          min: 0,
          max: 250_000,
          step: 1000,
          pips: true,
          pips_mode: "values",
          pips_values: [0, 50_000, 100_000, 150_000, 200_000, 250_000]
        }),
      featured:
        Boolean.new(:is_featured, "featured", %{
          label: "Featured",
          condition: dynamic([p], p.is_featured)
        }),
      in_stock:
        Boolean.new(:stock_quantity, "in_stock", %{
          label: "In stock",
          condition: dynamic([p], p.stock_quantity > 0)
        }),
      top_rated:
        Boolean.new(:rating, "top_rated", %{
          label: "Rated 4+",
          condition: dynamic([p], p.rating >= 4.0)
        })
    ]
  end

  defp id(id) do
    assigns = %{id: id}

    ~H"""
    <span class="font-mono text-xs text-muted-foreground">#{@id}</span>
    """
  end

  defp product(name, product) do
    assigns = %{name: name, sku: product.sku}

    ~H"""
    <.stacked main={@name} sub={@sku} mono />
    """
  end

  defp brand(brand, product) do
    assigns = %{brand: brand, category: product.category}

    ~H"""
    <.stacked main={@brand} sub={@category} />
    """
  end

  def table_options do
    %{
      pagination: %{sizes: [25, 50], default_size: 25},
      sorting: %{default_sort: [id: :desc]},
      search: %{placeholder: "Search a million products"},
      exports: %{enabled: true, formats: [:csv, :pdf]},
      fixed_header: true
    }
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <Layouts.demo
        path="/flagship"
        title="A million products"
        rows="1M rows"
        source={__source__()}
        try="Filter to one category, sort by price, then export what's left as CSV or PDF."
      >
        <:intro>
          Two joins, a computed margin, five filters and exports, over a million rows. Every
          sort, filter and page runs in the database.
        </:intro>
        <.live_table fields={fields()} filters={filters()} options={@options} streams={@streams} />
      </Layouts.demo>
    </Layouts.app>
    """
  end
end
