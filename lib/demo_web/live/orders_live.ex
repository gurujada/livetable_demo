defmodule DemoWeb.OrdersLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Orders.Order

  alias LiveTable.{Boolean, Range, Select}

  def fields do
    [
      id: %{label: "ID", hidden: true},
      order_number: %{label: "Order", sortable: true, searchable: true, renderer: &order/2},
      customer_name: %{label: "Customer", sortable: true, searchable: true, renderer: &customer/2},
      city: %{label: "City", sortable: true, renderer: &city/2},
      status: %{label: "Status", renderer: &status/1},
      payment_status: %{label: "Payment", renderer: &status/1},
      total_amount: %{label: "Amount", sortable: true, renderer: &money/1},
      items_count: %{label: "Items", sortable: true, renderer: &items/1},
      order_date: %{label: "Placed", sortable: true, renderer: &placed/1},
      customer_email: %{label: "Email", hidden: true},
      state: %{label: "State", hidden: true},
      is_express: %{label: "Express", hidden: true},
      is_gift: %{label: "Gift", hidden: true}
    ]
  end

  def filters do
    [
      status:
        Select.new(:status, "status", %{
          label: "Status",
          mode: :tags,
          options: for(s <- Demo.Orders.statuses(), do: %{label: String.capitalize(s), value: s})
        }),
      city:
        Select.new(:city, "city", %{
          label: "City",
          mode: :tags,
          placeholder: "Type a city",
          options_source: {Demo.Orders, :search_cities, []}
        }),
      amount:
        Range.new(:total_amount, "amount", %{
          label: "Amount",
          unit: "₹",
          min: 0,
          max: 100_000,
          step: 500,
          pips: true,
          pips_mode: "values",
          pips_values: [0, 25_000, 50_000, 75_000, 100_000]
        }),
      express:
        Boolean.new(:is_express, "express", %{
          label: "Express",
          condition: dynamic([o], o.is_express)
        }),
      gift: Boolean.new(:is_gift, "gift", %{label: "Gift", condition: dynamic([o], o.is_gift)})
    ]
  end

  defp customer(name, order) do
    assigns = %{name: name, email: order.customer_email}

    ~H"""
    <.person name={@name} sub={@email} />
    """
  end

  defp city(city, order) do
    assigns = %{city: city, state: order.state}

    ~H"""
    <.stacked main={@city} sub={@state} />
    """
  end

  defp items(count) do
    assigns = %{count: count}

    ~H"""
    <span class="inline-flex items-center gap-1.5 text-muted-foreground">
      <.icon name="lucide-package" class="size-3.5" />{@count}
    </span>
    """
  end

  defp placed(date) do
    assigns = %{date: date}

    ~H"""
    <.stacked main={date(@date)} sub={relative(@date)} />
    """
  end

  def table_options do
    %{
      pagination: %{sizes: [10, 25, 50], default_size: 25},
      sorting: %{default_sort: [order_date: :desc]},
      search: %{placeholder: "Search order or customer"},
      exports: %{enabled: false},
      fixed_header: true
    }
  end

  defp order(number, order) do
    assigns = %{number: number, order: order}

    ~H"""
    <div class="flex items-center gap-2">
      <span class="font-mono text-sm">{@number}</span>
      <span :if={@order.is_express} title="Express" class="text-amber-500">
        <.icon name="lucide-zap" class="size-3.5" />
      </span>
      <span :if={@order.is_gift} title="Gift" class="text-pink-500">
        <.icon name="lucide-gift" class="size-3.5" />
      </span>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <Layouts.demo
        path="/orders"
        title="Orders"
        rows="5K rows"
        source={__source__()}
        try="Pick two statuses, type a city, then copy the URL into a new tab."
      >
        <:intro>
          Select, search-as-you-type, range and toggle filters on one table. Every filter lives
          in the URL, so a filtered view is a link you can share.
        </:intro>
        <.live_table fields={fields()} filters={filters()} options={@options} streams={@streams} />
      </Layouts.demo>
    </Layouts.app>
    """
  end
end
