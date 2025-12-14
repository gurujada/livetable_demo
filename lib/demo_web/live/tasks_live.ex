defmodule DemoWeb.TasksLive do
  @moduledoc """
  Demo 2: Boolean Filters - Tasks
  Demonstrates: boolean checkbox filters with 1,000 rows.
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Tasks.Task

  alias LiveTable.Boolean

  def fields do
    [
      id: %{label: "ID", hidden: true},
      title: %{label: "Title", sortable: true, searchable: true},
      assigned_to: %{label: "Assigned To", searchable: true},
      due_date: %{label: "Due Date", sortable: true, renderer: &render_due_date/2},
      is_completed: %{label: "Completed", renderer: &render_boolean/1},
      is_urgent: %{label: "Urgent", renderer: &render_urgent/1},
      is_archived: %{label: "Archived", renderer: &render_boolean/1}
    ]
  end

  def filters do
    [
      completed:
        Boolean.new(:is_completed, "completed", %{
          label: "Completed",
          condition: dynamic([t], t.is_completed == true)
        }),
      urgent:
        Boolean.new(:is_urgent, "urgent", %{
          label: "Urgent",
          condition: dynamic([t], t.is_urgent == true)
        }),
      archived:
        Boolean.new(:is_archived, "archived", %{
          label: "Archived",
          condition: dynamic([t], t.is_archived == true)
        }),
      pending:
        Boolean.new(:is_completed, "pending", %{
          label: "Pending Only",
          condition: dynamic([t], t.is_completed == false)
        }),
      overdue:
        Boolean.new(:due_date, "overdue", %{
          label: "Overdue",
          condition: dynamic([t], t.due_date < ^Date.utc_today() and t.is_completed == false)
        })
    ]
  end

  def actions do
    %{
      label: "Actions",
      items: [
        toggle: &toggle_action/1,
        view: &view_action/1
      ]
    }
  end

  defp toggle_action(assigns) do
    ~H"""
    <button
      type="button"
      phx-click="toggle_complete"
      phx-value-id={@record.id}
      class={[
        "inline-flex items-center gap-1 px-2 py-1 text-xs font-medium rounded transition-colors",
        @record.is_completed && "text-yellow-600 hover:bg-yellow-50",
        !@record.is_completed && "text-green-600 hover:bg-green-50"
      ]}
    >
      <.icon
        name={if @record.is_completed, do: "lucide-rotate-ccw", else: "lucide-check"}
        class="size-3"
      />
      {if @record.is_completed, do: "Reopen", else: "Complete"}
    </button>
    """
  end

  defp view_action(assigns) do
    ~H"""
    <button
      type="button"
      phx-click="view_task"
      phx-value-id={@record.id}
      class="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium text-muted-foreground hover:text-foreground hover:bg-accent rounded transition-colors"
    >
      <.icon name="lucide-eye" class="size-3" /> View
    </button>
    """
  end

  def table_options do
    %{
      pagination: %{default_size: 25},
      sorting: %{default_sort: [due_date: :asc]},
      search: %{placeholder: "Search tasks..."}
    }
  end

  def handle_event("toggle_complete", %{"id" => id}, socket) do
    task = Demo.Tasks.get_task!(id)
    {:ok, _task} = Demo.Tasks.update_task(task, %{is_completed: !task.is_completed})

    socket =
      put_flash(socket, :info, "Task #{if task.is_completed, do: "reopened", else: "completed"}")

    {:noreply, socket}
  end

  def handle_event("view_task", %{"id" => _id}, socket) do
    socket =
      put_flash(socket, :info, "In a real app, this would navigate to the task detail page")

    {:noreply, socket}
  end

  defp render_boolean(value) do
    assigns = %{value: value}

    ~H"""
    <span class={[
      "px-2 py-1 text-xs rounded-full",
      if(@value, do: "bg-green-100 text-green-700", else: "bg-gray-100 text-gray-600")
    ]}>
      {if @value, do: "Yes", else: "No"}
    </span>
    """
  end

  defp render_urgent(value) do
    assigns = %{value: value}

    ~H"""
    <span :if={@value} class="px-2 py-1 text-xs rounded-full bg-red-100 text-red-700 font-medium">
      Urgent
    </span>
    <span :if={!@value} class="px-2 py-1 text-xs rounded-full bg-gray-100 text-gray-600">
      Normal
    </span>
    """
  end

  defp render_due_date(due_date, record) do
    is_overdue = Date.compare(due_date, Date.utc_today()) == :lt and not record.is_completed
    assigns = %{due_date: due_date, is_overdue: is_overdue}

    ~H"""
    <span class={[
      if(@is_overdue, do: "text-red-600 font-medium", else: "text-foreground")
    ]}>
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
          number={2}
          title="Tasks"
          rows="1K rows"
          description="Boolean filters for completed, urgent, archived, pending, and overdue tasks."
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
