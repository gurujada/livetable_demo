defmodule DemoWeb.LiveOrdersLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Live.Order

  alias Demo.Live.{Feed, Order}
  alias LiveTable.{Boolean, Select}

  def mount(_params, _session, socket) do
    # Rows update by themselves: the feed calls LiveTable.broadcast/3 whenever orders change.
    socket = LiveTable.subscribe(socket, Demo.PubSub, Feed.topic())
    {:ok, assign(socket, :stats, if(connected?(socket), do: Feed.watch()))}
  end

  def handle_info({:stats, stats}, socket), do: {:noreply, assign(socket, :stats, stats)}

  def handle_event("poke", _params, socket) do
    Feed.poke()
    {:noreply, socket}
  end

  def fields do
    [
      id: %{label: "ID", hidden: true},
      number: %{label: "Order", searchable: true, component: &fresh/1},
      inserted_at: %{label: "Placed", sortable: true, renderer: &time/1},
      customer: %{label: "Customer", searchable: true, renderer: &customer/2},
      amount: %{label: "Amount", sortable: true, renderer: &money/1},
      status: %{label: "Status", component: &fresh/1},
      city: %{label: "City", sortable: true, hidden: true},
      updated_at: %{label: "Updated", hidden: true}
    ]
  end

  defp customer(name, order) do
    assigns = %{name: name, city: order.city}

    ~H"""
    <.person name={@name} sub={@city} />
    """
  end

  def filters do
    [
      status:
        Select.new(:status, "status", %{
          label: "Status",
          mode: :tags,
          options: for(s <- Order.statuses(), do: %{label: String.capitalize(s), value: s})
        }),
      big:
        Boolean.new(:amount, "big", %{
          label: "Over ₹10,000",
          condition: dynamic([o], o.amount > 10_000)
        })
    ]
  end

  def bulk_actions do
    [
      pack: %{label: "Mark packed", handler: &move(&1, &2, "packed")},
      ship: %{label: "Mark shipped", handler: &move(&1, &2, "shipped")}
    ]
  end

  defp move(query, socket, status) do
    count = Feed.set_status(query, status)
    put_flash(socket, :info, "Marked #{count} orders #{status}.")
  end

  def table_options do
    %{
      pagination: %{sizes: [10, 25], default_size: 10},
      sorting: %{default_sort: [inserted_at: :desc]},
      search: %{placeholder: "Search order or customer"},
      exports: %{enabled: false}
    }
  end

  # A cell that was just changed flashes, like a highlighter. Only changed rows are sent
  # again, so only they flash.
  defp fresh(assigns) do
    ~H"""
    <span class={[
      "px-1 -mx-1 py-0.5",
      DateTime.diff(DateTime.utc_now(), @record.updated_at, :millisecond) < 2500 && "is-fresh"
    ]}>
      <.pill :if={@value in Order.statuses()} value={@value} />
      <span :if={@value not in Order.statuses()} class="font-semibold tabular-nums">#{@value}</span>
    </span>
    """
  end

  defp time(at), do: Calendar.strftime(at, "%H:%M:%S")

  attr :label, :string, required: true
  attr :value, :any, required: true

  defp tile(assigns) do
    ~H"""
    <div class="rounded-lg border border-rule bg-card p-4">
      <p class="text-sm text-quiet">{@label}</p>
      <p class="mt-1 text-2xl font-bold sm:text-3xl">{@value}</p>
    </div>
    """
  end

  # The last orders' amounts, newest on the right.
  attr :amounts, :list, required: true

  defp chart(assigns) do
    max = assigns.amounts |> Enum.map(&Decimal.to_float/1) |> Enum.max(fn -> 1.0 end)
    count = max(length(assigns.amounts), 1)
    assigns = assign(assigns, max: max, width: 100 / count, count: count)

    ~H"""
    <div class="flex flex-col rounded-lg border border-rule bg-card p-4">
      <p class="text-sm text-quiet">Latest orders, by amount</p>
      <svg
        viewBox="0 0 100 40"
        preserveAspectRatio="none"
        class="mt-3 min-h-24 w-full flex-1"
        aria-hidden="true"
      >
        <rect
          :for={{amount, i} <- Enum.with_index(@amounts)}
          x={i * @width + @width * 0.15}
          width={@width * 0.7}
          y={40 - Decimal.to_float(amount) / @max * 38}
          height={Decimal.to_float(amount) / @max * 38}
          rx="0.4"
          class={if i == @count - 1, do: "fill-marker", else: "fill-signal/70"}
        />
      </svg>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <Layouts.demo
        path="/live"
        title="Live orders"
        rows="Live"
        source={__source__()}
        try="Open this page in a second window, then select a few orders and mark them shipped."
      >
        <:intro>
          A shop's order feed. New orders land in place and changed rows flash, in every open
          window, without a reload.
        </:intro>

        <div class="mb-8 grid gap-3 lg:grid-cols-2">
          <div class="grid grid-cols-2 gap-3">
            <.tile label="Orders" value={@stats && @stats.orders} />
            <.tile label="Revenue" value={@stats && money(@stats.revenue)} />
            <.tile label="To ship" value={@stats && @stats.waiting} />
            <.tile label="Shipped" value={@stats && @stats.shipped} />
          </div>
          <.chart amounts={(@stats && @stats.recent) || []} />
        </div>

        <div class="mb-2 flex justify-end">
          <button type="button" phx-click="poke" class="btn btn-outline">
            <.icon name="lucide-zap" class="size-4" /> Make a change
          </button>
        </div>

        <.live_table
          fields={fields()}
          filters={filters()}
          options={@options}
          streams={@streams}
          bulk_actions={bulk_actions()}
        />
      </Layouts.demo>
    </Layouts.app>
    """
  end
end
