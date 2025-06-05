defmodule DemoWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is rendered as component
  in regular views and live views.
  """
  use DemoWeb, :html

  embed_templates "layouts/*"

  @doc """
  Renders the app layout

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layout.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar bg-base-100 shadow-sm border-b border-base-200 px-6">
      <div class="flex-1">
        <a href="/" class="flex items-center gap-3 hover:opacity-80 transition-opacity">
          <div class="avatar placeholder">
            <div class="bg-primary text-primary-content rounded-full w-10 h-10 flex items-center justify-center">
              <span class="text-lg font-bold">LT</span>
            </div>
          </div>
          <div>
            <div class="font-bold text-xl">LiveTable</div>
            <div class="text-sm opacity-60">Demo Application</div>
          </div>
        </a>
      </div>
      <div class="flex-none">
        <div class="flex items-center gap-4">
          <.theme_toggle />
        </div>
      </div>
    </header>

    <main class="min-h-screen">
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/2 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=dark]_&]:left-1/2 transition-[left] duration-200 ease-in-out" />

      <button
        phx-click={JS.dispatch("phx:set-theme", detail: %{theme: "light"})}
        class="flex items-center justify-center p-2 cursor-pointer w-1/2 relative z-10 [[data-theme=light]_&]:opacity-100 [[data-theme=dark]_&]:opacity-75 hover:opacity-100 transition-opacity"
      >
        <.icon name="hero-sun-micro" class="size-4" />
      </button>

      <button
        phx-click={JS.dispatch("phx:set-theme", detail: %{theme: "dark"})}
        class="flex items-center justify-center p-2 cursor-pointer w-1/2 relative z-10 [[data-theme=dark]_&]:opacity-100 [[data-theme=light]_&]:opacity-75 hover:opacity-100 transition-opacity"
      >
        <.icon name="hero-moon-micro" class="size-4" />
      </button>
    </div>
    """
  end
end
