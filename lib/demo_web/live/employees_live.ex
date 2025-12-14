defmodule DemoWeb.EmployeesLive do
  @moduledoc """
  Demo 3: Range Filters - Employees
  Demonstrates: range filters for salary and experience (2,000 rows).
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Employees.Employee

  alias DemoWeb.Layouts
  alias LiveTable.{Boolean, Range}
  import DemoWeb.Helpers, only: [format_currency: 1]

  def fields do
    [
      id: %{label: "ID", hidden: true},
      employee_id: %{label: "Emp ID"},
      name: %{label: "Name", sortable: true, searchable: true},
      department: %{label: "Department", sortable: true, searchable: true},
      designation: %{label: "Designation", searchable: true},
      salary: %{label: "Salary", sortable: true, renderer: &format_salary/1},
      experience_years: %{label: "Experience", renderer: &format_experience/1},
      is_active: %{label: "Status", renderer: &render_status/1}
    ]
  end

  def filters do
    [
      salary_range:
        Range.new(:salary, "salary_range", %{
          type: :number,
          label: "Salary Range",
          unit: "₹",
          min: 300_000,
          max: 5_000_000,
          step: 100_000,
          default_min: 300_000,
          default_max: 5_000_000,
          pips: true
        }),
      experience_range:
        Range.new(:experience_years, "experience_range", %{
          type: :number,
          label: "Experience (years)",
          min: 0,
          max: 30,
          step: 1,
          default_min: 0,
          default_max: 30,
          pips: true
        }),
      active_only:
        Boolean.new(:is_active, "active", %{
          label: "Active Only",
          condition: dynamic([e], e.is_active == true)
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
      phx-click="view_employee"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-eye" class="size-4" /> View Details
    </button>
    """
  end

  defp email_action(assigns) do
    ~H"""
    <button
      phx-click="email_employee"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-mail" class="size-4" /> Send Email
    </button>
    """
  end

  def table_options do
    %{
      pagination: %{
        default_size: 50
      },
      sorting: %{
        default_sort: [name: :asc]
      },
      search: %{
        placeholder: "Search employees..."
      },
      fixed_header: true
    }
  end

  def handle_event("view_employee", %{"id" => _id}, socket) do
    {:noreply,
     put_flash(socket, :info, "In a real app, this would navigate to the employee profile")}
  end

  def handle_event("email_employee", %{"id" => _id}, socket) do
    {:noreply, put_flash(socket, :info, "In a real app, this would open the email composer")}
  end

  defp format_salary(salary) do
    formatted = format_currency(salary)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono text-green-700 dark:text-green-400">₹{@formatted}</span>
    """
  end

  defp format_experience(years) do
    assigns = %{years: years}

    ~H"""
    <span>
      {@years} {if @years == 1, do: "year", else: "years"}
    </span>
    """
  end

  defp render_status(is_active) do
    assigns = %{is_active: is_active}

    ~H"""
    <span class={[
      "px-2 py-1 text-xs rounded-full",
      if(@is_active,
        do: "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400",
        else: "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400"
      )
    ]}>
      {if @is_active, do: "Active", else: "Inactive"}
    </span>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={3}
          title="Employees"
          rows="2K rows"
          description="Range filters for salary, experience, and joining dates. Demonstrates numeric and date range filtering."
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
