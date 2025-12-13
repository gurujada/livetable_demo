defmodule DemoWeb.ContactsLive do
  @moduledoc """
  Demo 1: Basic Table - Contacts
  Demonstrates: sorting, pagination, search, and row actions with 500 rows.
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Contacts.Contact

  def fields do
    [
      id: %{label: "ID", sortable: true},
      name: %{label: "Name", sortable: true, searchable: true},
      email: %{label: "Email", searchable: true, sortable: false},
      phone: %{label: "Phone", sortable: false},
      city: %{label: "City", sortable: true, searchable: true}
    ]
  end

  def filters do
    []
  end

  def actions do
    %{
      label: "Actions",
      items: [
        view: &view_action/1,
        # email: &email_action/1
      ]
    }
  end

  defp view_action(assigns) do
    ~H"""
    <button
      type="button"
      phx-click="view_contact"
      phx-value-id={@record.id}
      class="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium text-primary hover:text-primary/80 hover:bg-primary/10 rounded transition-colors"
    >
      <.icon name="lucide-eye" class="size-3" /> View
    </button>
    """
  end

  defp email_action(assigns) do
    ~H"""
    <a
      href={"mailto:#{@record.email}"}
      class="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium text-muted-foreground hover:text-foreground hover:bg-accent rounded transition-colors"
    >
      <.icon name="lucide-mail" class="size-3" /> Email
    </a>
    """
  end

  def table_options do
    %{
      pagination: %{
        enabled: true,
        sizes: [10, 25, 50],
        default_size: 10
      },
      sorting: %{
        enabled: true,
        default_sort: [id: :asc]
      },
      search: %{
        enabled: true,
        debounce: 300,
        placeholder: "Search contacts..."
      }
    }
  end

  def handle_event("view_contact", %{"id" => id}, socket) do
    contact = Demo.Contacts.get_contact!(id)

    socket =
      socket
      |> put_flash(:info, "In a real app, this would navigate to #{contact.name}'s detail page")

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={1}
          title="Contacts"
          rows="500 rows"
          description="Basic table with sorting, pagination, search, and row actions."
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
