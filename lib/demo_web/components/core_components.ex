defmodule DemoWeb.CoreComponents do
  use Phoenix.Component

  attr :name, :string, required: true, doc: "The Lucide icon name (must start with 'lucide-')"
  attr :class, :any, default: "size-4", doc: "Additional CSS classes"
  attr :title, :string, default: nil, doc: "Title attribute for tooltip on hover"
  attr :rest, :global, include: ~w(aria-label role)

  def icon(%{name: "lucide-" <> _} = assigns) do
    # If aria-label is provided, the icon is meaningful, so don't hide it from screen readers
    # Otherwise, default to aria-hidden="true" for decorative icons
    assigns =
      assign_new(assigns, :aria_hidden, fn ->
        if assigns[:rest][:"aria-label"], do: nil, else: "true"
      end)

    ~H"""
    <span
      class={[@name, @class]}
      title={@title}
      aria-hidden={@aria_hidden}
      {@rest}
    />
    """
  end
end
