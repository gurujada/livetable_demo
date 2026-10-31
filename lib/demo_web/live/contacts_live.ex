defmodule DemoWeb.ContactsLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Contacts.Contact

  def fields do
    [
      id: %{label: "ID", sortable: true, renderer: &id/1},
      name: %{label: "Name", sortable: true, searchable: true, renderer: &name/2},
      email: %{label: "Email", searchable: true, renderer: &with_icon(&1, "lucide-mail")},
      phone: %{label: "Phone", renderer: &with_icon(&1, "lucide-phone")},
      city: %{
        label: "City",
        sortable: true,
        searchable: true,
        renderer: &with_icon(&1, "lucide-map-pin")
      }
    ]
  end

  def filters, do: []

  def actions do
    %{label: "", items: [email: &email_action/1]}
  end

  defp email_action(assigns) do
    ~H"""
    <a href={"mailto:#{@record.email}"} class="text-sm font-medium text-cyan-500 hover:underline">
      Email
    </a>
    """
  end

  defp id(id) do
    assigns = %{id: id}

    ~H"""
    <span class="font-mono text-xs text-muted-foreground">#{@id}</span>
    """
  end

  defp name(name, contact) do
    assigns = %{name: name, city: contact.city}

    ~H"""
    <.person name={@name} sub={@city} />
    """
  end

  defp with_icon(text, icon) do
    assigns = %{text: text, icon: icon}

    ~H"""
    <span class="inline-flex items-center gap-2 text-muted-foreground">
      <.icon name={@icon} class="size-3.5 shrink-0 text-cyan-500/70" />
      <span class="text-foreground/90">{@text}</span>
    </span>
    """
  end

  def table_options do
    %{search: %{placeholder: "Search name, email or city"}, exports: %{enabled: false}}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <Layouts.demo
        path="/contacts"
        title="Contacts"
        rows="500 rows"
        source={__source__()}
        try="Shift-click a second column header to sort by both."
      >
        <:intro>A table straight from an Ecto schema. No query to write.</:intro>
        <.live_table
          fields={fields()}
          filters={filters()}
          actions={actions()}
          options={@options}
          streams={@streams}
        />
      </Layouts.demo>
    </Layouts.app>
    """
  end
end
