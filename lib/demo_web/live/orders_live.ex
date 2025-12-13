defmodule DemoWeb.OrdersLive do
  @moduledoc """
  Demo 5: All Filters Combined - Orders
  Demonstrates: boolean, range, and select filters combined (5,000 rows).

  TODO: status, payment_status, and state are currently plain string fields.
  Select filters require proper relationships (belongs_to lookup tables) to work correctly.
  See database_tasks.md for the required schema changes.
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Orders.Order

  alias DemoWeb.Layouts
  alias LiveTable.{Boolean, Range}
  import DemoWeb.Helpers, only: [format_currency: 1]

  def fields do
    [
      id: %{label: "ID", hidden: true, sortable: false},
      order_number: %{label: "Order #", sortable: true, searchable: true},
      customer_name: %{label: "Customer", sortable: true, searchable: true},
      city: %{label: "City", searchable: true, sortable: false},
      status: %{label: "Status", renderer: &render_status/1, sortable: false},
      payment_status: %{label: "Payment", renderer: &render_payment_status/1, sortable: false},
      total_amount: %{label: "Amount", sortable: true, renderer: &format_amount/1},
      items_count: %{label: "Items", sortable: false},
      order_date: %{label: "Date", sortable: true, renderer: &format_date/1}
    ]
  end

  # TODO: Add Select filters for status, payment_status, and state once lookup tables are created
  # See database_tasks.md for details
  def filters do
    [
      amount_range:
        Range.new(:total_amount, "amount_range", %{
          type: :number,
          label: "Order Amount",
          unit: "₹",
          min: 500,
          max: 100_000,
          step: 1000
        }),
      # NOTE: Date Range filters are NOT supported by LiveTable (Range only supports :number)
      # See database_tasks.md for details
      express:
        Boolean.new(:is_express, "express", %{
          label: "Express Delivery",
          condition: dynamic([o], o.is_express == true)
        }),
      gift:
        Boolean.new(:is_gift, "gift", %{
          label: "Gift Orders",
          condition: dynamic([o], o.is_gift == true)
        }),
      high_value:
        Boolean.new(:total_amount, "high_value", %{
          label: "High Value (₹10K+)",
          condition: dynamic([o], o.total_amount >= 10000)
        })
    ]
  end

  def actions do
    %{
      label: "Actions",
      items: [
        view: &view_action/1,
        track: &track_action/1
      ]
    }
  end

  defp view_action(assigns) do
    ~H"""
    <button
      phx-click="view_order"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-eye" class="size-4" /> View Details
    </button>
    """
  end

  defp track_action(assigns) do
    ~H"""
    <button
      phx-click="track_order"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-truck" class="size-4" /> Track Shipment
    </button>
    """
  end

  # TODO: This will be used once IndianStates lookup table is created
  # defp get_state_options do
  #   ~w(Maharashtra Karnataka Tamil\ Nadu Gujarat Rajasthan Uttar\ Pradesh West\ Bengal Telangana Kerala Punjab Haryana Delhi)
  #   |> Enum.map(&%{label: &1, value: [&1]})
  # end

  def table_options do
    %{
      pagination: %{
        enabled: true,
        sizes: [10, 25, 50, 100],
        default_size: 25
      },
      sorting: %{
        enabled: true,
        default_sort: [order_date: :desc]
      },
      search: %{
        enabled: true,
        debounce: 300,
        placeholder: "Search orders..."
      }
    }
  end

  def handle_event("view_order", %{"id" => _id}, socket) do
    {:noreply,
     put_flash(socket, :info, "In a real app, this would navigate to the order detail page")}
  end

  def handle_event("track_order", %{"id" => _id}, socket) do
    {:noreply, put_flash(socket, :info, "In a real app, this would show shipment tracking info")}
  end

  defp render_status(status) do
    {bg, text} =
      case status do
        "pending" ->
          {"bg-yellow-100 dark:bg-yellow-900/30", "text-yellow-700 dark:text-yellow-400"}

        "confirmed" ->
          {"bg-blue-100 dark:bg-blue-900/30", "text-blue-700 dark:text-blue-400"}

        "shipped" ->
          {"bg-purple-100 dark:bg-purple-900/30", "text-purple-700 dark:text-purple-400"}

        "delivered" ->
          {"bg-green-100 dark:bg-green-900/30", "text-green-700 dark:text-green-400"}

        "cancelled" ->
          {"bg-red-100 dark:bg-red-900/30", "text-red-700 dark:text-red-400"}

        _ ->
          {"bg-gray-100 dark:bg-gray-800", "text-gray-700 dark:text-gray-400"}
      end

    assigns = %{status: status, bg: bg, text: text}

    ~H"""
    <span class={["px-2 py-1 text-xs rounded-full capitalize", @bg, @text]}>
      {@status}
    </span>
    """
  end

  defp render_payment_status(status) do
    {bg, text} =
      case status do
        "paid" ->
          {"bg-green-100 dark:bg-green-900/30", "text-green-700 dark:text-green-400"}

        "pending" ->
          {"bg-yellow-100 dark:bg-yellow-900/30", "text-yellow-700 dark:text-yellow-400"}

        "refunded" ->
          {"bg-red-100 dark:bg-red-900/30", "text-red-700 dark:text-red-400"}

        "partially_paid" ->
          {"bg-orange-100 dark:bg-orange-900/30", "text-orange-700 dark:text-orange-400"}

        _ ->
          {"bg-gray-100 dark:bg-gray-800", "text-gray-700 dark:text-gray-400"}
      end

    display = String.replace(status, "_", " ")
    assigns = %{display: display, bg: bg, text: text}

    ~H"""
    <span class={["px-2 py-1 text-xs rounded-full capitalize", @bg, @text]}>
      {@display}
    </span>
    """
  end

  defp format_amount(amount) do
    formatted = format_currency(amount)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono text-green-700 dark:text-green-400">₹{@formatted}</span>
    """
  end

  defp format_date(date) do
    assigns = %{date: date}

    ~H"""
    <span>{Calendar.strftime(@date, "%d %b %Y")}</span>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={5}
          title="Orders"
          rows="5K rows"
          description="All filter types combined - boolean, range, and select filters working together."
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
