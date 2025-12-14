defmodule DemoWeb.InvoicesLive do
  @moduledoc """
  Demo 6: Joins & Associations - Invoices
  Demonstrates: multi-table joins with customer and payment_term (8,000 rows).
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource

  import Ecto.Query
  alias DemoWeb.Layouts
  alias LiveTable.{Boolean, Range}
  import DemoWeb.Helpers, only: [format_currency: 1]

  def mount(_params, _session, socket) do
    socket = assign(socket, :data_provider, {__MODULE__, :base_query, []})
    {:ok, socket}
  end

  def base_query do
    from i in Demo.Invoices.Invoice,
      join: c in assoc(i, :customer),
      as: :customer,
      join: pt in assoc(i, :payment_term),
      as: :payment_term,
      select: %{
        id: i.id,
        invoice_number: i.invoice_number,
        amount: i.amount,
        tax_amount: i.tax_amount,
        total: i.amount + coalesce(i.tax_amount, 0),
        status: i.status,
        issue_date: i.issue_date,
        due_date: i.due_date,
        customer_name: c.name,
        customer_city: c.city,
        payment_term_name: pt.name,
        payment_term_days: pt.days
      }
  end

  def fields do
    [
      id: %{label: "ID", hidden: true},
      invoice_number: %{label: "Invoice #", sortable: true, searchable: true},
      customer_name: %{
        label: "Customer",
        sortable: true,
        searchable: true,
        assoc: {:customer, :name}
      },
      customer_city: %{label: "City", assoc: {:customer, :city}},
      amount: %{label: "Amount", renderer: &format_amount/1},
      tax_amount: %{label: "Tax", renderer: &format_tax/1},
      total: %{label: "Total", sortable: true, renderer: &format_total/1},
      status: %{label: "Status", renderer: &render_status/1},
      payment_term_name: %{label: "Payment Terms", assoc: {:payment_term, :name}},
      issue_date: %{label: "Issue Date", sortable: true, renderer: &format_date/1},
      due_date: %{label: "Due Date", renderer: &render_due_date/1}
    ]
  end

  def filters do
    [
      amount_range:
        Range.new(:amount, "amount_range", %{
          type: :number,
          label: "Amount Range",
          unit: "₹",
          min: 1000,
          max: 500_000,
          step: 5000,
          pips: true
        }),
      overdue:
        Boolean.new(:due_date, "overdue", %{
          label: "Overdue Only",
          condition:
            dynamic(
              [i],
              i.due_date < ^Date.utc_today() and i.status != "paid" and i.status != "cancelled"
            )
        }),
      paid:
        Boolean.new(:status, "paid", %{
          label: "Paid Only",
          condition: dynamic([i], i.status == "paid")
        })
    ]
  end

  def actions do
    %{
      label: "Actions",
      items: [
        view: &view_action/1,
        download: &download_action/1
      ]
    }
  end

  defp view_action(assigns) do
    ~H"""
    <button
      phx-click="view_invoice"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-eye" class="size-4" /> View Invoice
    </button>
    """
  end

  defp download_action(assigns) do
    ~H"""
    <button
      phx-click="download_invoice"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-download" class="size-4" /> Download PDF
    </button>
    """
  end

  def table_options do
    %{
      pagination: %{default_size: 50},
      sorting: %{default_sort: [issue_date: :desc]},
      search: %{placeholder: "Search invoices..."},
      fixed_header: true
    }
  end

  def handle_event("view_invoice", %{"id" => _id}, socket) do
    {:noreply,
     put_flash(socket, :info, "In a real app, this would navigate to the invoice detail page")}
  end

  def handle_event("download_invoice", %{"id" => _id}, socket) do
    {:noreply, put_flash(socket, :info, "In a real app, this would download the invoice PDF")}
  end

  defp format_amount(amount) do
    formatted = format_currency(amount)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono">₹{@formatted}</span>
    """
  end

  defp format_tax(nil) do
    assigns = %{}

    ~H"""
    <span class="text-muted-foreground">-</span>
    """
  end

  defp format_tax(amount) do
    formatted = format_currency(amount)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono text-muted-foreground">₹{@formatted}</span>
    """
  end

  defp format_total(amount) do
    formatted = format_currency(amount)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono font-medium text-green-700 dark:text-green-400">₹{@formatted}</span>
    """
  end

  defp render_status(status) do
    {bg, text} =
      case status do
        "draft" ->
          {"bg-gray-100 dark:bg-gray-800", "text-gray-700 dark:text-gray-400"}

        "sent" ->
          {"bg-blue-100 dark:bg-blue-900/30", "text-blue-700 dark:text-blue-400"}

        "paid" ->
          {"bg-green-100 dark:bg-green-900/30", "text-green-700 dark:text-green-400"}

        "overdue" ->
          {"bg-red-100 dark:bg-red-900/30", "text-red-700 dark:text-red-400"}

        "cancelled" ->
          {"bg-yellow-100 dark:bg-yellow-900/30", "text-yellow-700 dark:text-yellow-400"}

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

  defp format_date(date) do
    assigns = %{date: date}

    ~H"""
    {Calendar.strftime(@date, "%d %b %Y")}
    """
  end

  defp render_due_date(due_date) do
    is_overdue = Date.compare(due_date, Date.utc_today()) == :lt
    assigns = %{due_date: due_date, is_overdue: is_overdue}

    ~H"""
    <span class={if @is_overdue, do: "text-red-600 dark:text-red-400 font-medium", else: ""}>
      {Calendar.strftime(@due_date, "%d %b %Y")}
      <span :if={@is_overdue} class="text-xs">(overdue)</span>
    </span>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={6}
          title="Invoices"
          rows="8K rows"
          description="Joins & associations - customer and payment terms data from related tables."
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
