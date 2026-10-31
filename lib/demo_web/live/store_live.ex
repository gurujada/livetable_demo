defmodule DemoWeb.StoreLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Store.Product

  alias Demo.Store.Product
  alias LiveTable.{Boolean, Range, Select}

  def fields do
    [
      name: %{label: "Name", searchable: true},
      category: %{label: "Category", searchable: true},
      price: %{label: "Price", sortable: true},
      rating: %{label: "Rating", sortable: true},
      reviews: %{label: "Reviews", sortable: true},
      image: %{label: "Image", hidden: true},
      in_stock: %{label: "In stock", hidden: true},
      is_new: %{label: "New", hidden: true}
    ]
  end

  def filters do
    [
      category: Select.new(:category, "category", %{label: "Category", options: []}),
      price:
        Range.new(:price, "price", %{
          label: "Price",
          unit: "₹",
          min: 0,
          max: 150_000,
          step: 5000,
          pips: true,
          pips_mode: "values",
          pips_values: [0, 50_000, 100_000, 150_000]
        }),
      in_stock:
        Boolean.new(:in_stock, "in_stock", %{
          label: "In stock",
          condition: dynamic([p], p.in_stock)
        }),
      top_rated:
        Boolean.new(:rating, "top_rated", %{
          label: "4.5 and up",
          condition: dynamic([p], p.rating >= 4.5)
        }),
      new:
        Boolean.new(:is_new, "new", %{label: "New arrivals", condition: dynamic([p], p.is_new)})
    ]
  end

  def table_options do
    %{
      mode: :card,
      card_component: &product/1,
      custom_controls: {__MODULE__, :sidebar},
      empty_state: &nothing_found/1,
      pagination: %{sizes: [12], default_size: 12},
      sorting: %{default_sort: [reviews: :desc]},
      exports: %{enabled: false}
    }
  end

  # The table's own controls, redrawn as a shop's sidebar. Inputs use LiveTable's param names.
  def sidebar(assigns) do
    ~H"""
    <form id="store-controls" phx-change="sort" class="mt-4 space-y-7 pb-6">
      <input
        type="search"
        name="search"
        value={@options["filters"]["search"]}
        placeholder="Search the shop"
        phx-debounce="250"
        class="input w-full"
      />

      <fieldset>
        <legend class="mb-2 text-sm font-semibold">Category</legend>
        <input type="hidden" name="filters[category][id][]" value="" />
        <div class="flex flex-wrap gap-2">
          <label
            :for={category <- Product.categories()}
            class="flex cursor-pointer items-center gap-1.5 rounded-full border border-rule px-3 py-1.5 text-sm has-[:checked]:border-foreground has-[:checked]:bg-foreground has-[:checked]:text-background"
          >
            <input
              type="checkbox"
              name="filters[category][id][]"
              value={category}
              checked={category in selected(@options, :category)}
              class="sr-only"
            />
            <.icon name={Product.icon(category)} class="size-3.5" />
            {category}
          </label>
        </div>
      </fieldset>

      <div class="pb-6">
        {LiveTable.Range.render(%{
          key: :price,
          filter: @filters[:price],
          applied_filters: @options["filters"]
        })}
      </div>

      <fieldset class="space-y-2">
        <legend class="mb-2 text-sm font-semibold">Show only</legend>
        <label :for={key <- [:in_stock, :top_rated, :new]} class="flex items-center gap-2 text-sm">
          <input type="hidden" name={"filters[#{key}]"} value="false" />
          <input
            type="checkbox"
            name={"filters[#{key}]"}
            value="true"
            checked={Map.has_key?(@options["filters"], key)}
            class="size-4 accent-signal"
          />
          {@filters[key].options.label}
        </label>
      </fieldset>

      <fieldset>
        <legend class="mb-2 text-sm font-semibold">Sort</legend>
        <div class="grid grid-cols-2 gap-1 text-sm">
          <button
            :for={
              {label, sort} <- [
                {"Popular", %{reviews: :desc}},
                {"Top rated", %{rating: :desc}},
                {"Cheapest", %{price: :asc}},
                {"Priciest", %{price: :desc}}
              ]
            }
            type="button"
            phx-click="sort"
            phx-value-sort={JSON.encode!(sort)}
            class={[
              "rounded-md border px-2 py-1.5",
              sorted_by?(@options, sort) && "border-foreground bg-foreground text-background",
              !sorted_by?(@options, sort) && "border-rule hover:border-quiet"
            ]}
          >
            {label}
          </button>
        </div>
      </fieldset>
    </form>
    """
  end

  defp selected(options, key) do
    case options["filters"][key] do
      %Select{options: %{selected: selected}} -> selected
      _ -> []
    end
  end

  defp sorted_by?(options, sort),
    do: options["sort"]["sort_params"] == Enum.to_list(sort)

  defp product(assigns) do
    ~H"""
    <article class="group flex h-full flex-col">
      <div class="relative aspect-[4/3] overflow-hidden rounded-xl bg-muted">
        <img
          src={"/images/store/#{@record.image}.jpg"}
          alt={@record.name}
          loading="lazy"
          class={[
            "h-full w-full object-cover transition-transform duration-500 group-hover:scale-105",
            !@record.in_stock && "grayscale opacity-60"
          ]}
        />
        <span
          :if={@record.is_new}
          class="absolute left-3 top-3 rounded-full bg-cyan-500 px-2 py-0.5 text-xs font-semibold text-white"
        >
          New
        </span>
        <span
          :if={!@record.in_stock}
          class="absolute right-3 top-3 rounded-full bg-background/90 px-2 py-0.5 text-xs font-medium"
        >
          Sold out
        </span>
      </div>
      <p class="mt-3 text-xs text-muted-foreground">{@record.category}</p>
      <h3 class="truncate font-semibold text-foreground">{@record.name}</h3>
      <div class="mt-1 flex items-center gap-1.5 text-sm">
        <span class="text-amber-400">{stars(@record.rating)}</span>
        <span class="text-muted-foreground">({@record.reviews})</span>
      </div>
      <div class="mt-1 flex flex-wrap items-baseline gap-x-2">
        <span class="text-lg font-bold">₹{format_currency(@record.price)}</span>
        <span class="text-sm text-muted-foreground line-through">
          ₹{format_currency(list_price(@record.price))}
        </span>
        <span class="text-sm font-medium text-green-600 dark:text-green-400">20% off</span>
      </div>
      <button
        type="button"
        phx-click="add_to_cart"
        phx-value-name={@record.name}
        disabled={!@record.in_stock}
        class="btn btn-outline mt-3 w-full disabled:opacity-50"
      >
        {if @record.in_stock, do: "Add to cart", else: "Sold out"}
      </button>
    </article>
    """
  end

  defp stars(rating) do
    full = rating |> Decimal.round(0) |> Decimal.to_integer()
    String.duplicate("★", full) <> String.duplicate("☆", 5 - full)
  end

  defp list_price(price), do: price |> Decimal.mult(Decimal.new("1.25")) |> Decimal.round(-2)

  def handle_event("add_to_cart", %{"name" => name}, socket) do
    {:noreply, put_flash(socket, :info, "Added #{name} to your cart.")}
  end

  defp nothing_found(assigns) do
    ~H"""
    <div class="rounded-lg border border-dashed border-rule p-12 text-center">
      <p class="font-semibold">Nothing matches those filters.</p>
      <button
        type="button"
        phx-click="sort"
        phx-value-clear_filters="true"
        class="mt-3 text-sm text-cyan-500 underline"
      >
        Clear filters
      </button>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <Layouts.demo
        path="/store"
        title="Storefront"
        rows="360 rows"
        source={__source__()}
        try="Pick a category or two, then sort by price."
      >
        <:intro>
          A shop page that's really a LiveTable: the cards, sidebar and empty state are all yours.
        </:intro>
        <div class="storefront">
          <.live_table fields={fields()} filters={filters()} options={@options} streams={@streams} />
        </div>
      </Layouts.demo>
    </Layouts.app>
    """
  end
end
