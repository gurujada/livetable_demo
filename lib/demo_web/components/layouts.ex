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
          <a
            href="https://hex.pm/packages/live_table"
            target="_blank"
            rel="noopener noreferrer"
            class="btn btn-ghost btn-circle hover:bg-base-200 transition-colors"
            title="Documentation"
          >
            <.icon name="hero-document-text" class="size-5" />
          </a>

          <a
            href="https://github.com/gurujada/livetable_demo"
            target="_blank"
            rel="noopener noreferrer"
            class="btn btn-ghost btn-circle hover:bg-base-200 transition-colors"
            title="GitHub Repository"
          >
            <svg
              viewBox="0 0 24 24"
              aria-hidden="true"
              class="size-6 fill-slate-900 dark:fill-gray-100"
            >
              <path
                fill-rule="evenodd"
                clip-rule="evenodd"
                d="M12 2C6.477 2 2 6.463 2 11.97c0 4.404 2.865 8.14 6.839 9.458.5.092.682-.216.682-.48 0-.236-.008-.864-.013-1.695-2.782.602-3.369-1.337-3.369-1.337-.454-1.151-1.11-1.458-1.11-1.458-.908-.618.069-.606.069-.606 1.003.07 1.531 1.027 1.531 1.027.892 1.524 2.341 1.084 2.91.828.092-.643.35-1.083.636-1.332-2.22-.251-4.555-1.107-4.555-4.927 0-1.088.39-1.979 1.029-2.675-.103-.252-.446-1.266.098-2.638 0 0 .84-.268 2.75 1.022A9.607 9.607 0 0 1 12 6.82c.85.004 1.705.114 2.504.336 1.909-1.29 2.747-1.022 2.747-1.022.546 1.372.202 2.386.1 2.638.64.696 1.028 1.587 1.028 2.675 0 3.83-2.339 4.673-4.566 4.92.359.307.678.915.678 1.846 0 1.332-.012 2.407-.012 2.734 0 .267.18.577.688.48 3.97-1.32 6.833-5.054 6.833-9.458C22 6.463 17.522 2 12 2Z"
              >
              </path>
            </svg>
          </a>

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
