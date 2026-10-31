defmodule DemoWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is rendered as component
  in regular views and live views.
  """
  use DemoWeb, :html

  def live_table_version, do: to_string(Application.spec(:live_table, :vsn))

  defp live_table_changelog_url,
    do: "https://github.com/gurujada/live_table/blob/master/CHANGELOG.md"

  embed_templates("layouts/*")

  @demos [
    %{path: "/contacts", name: "Contacts", number: 1, badge: "500", desc: "Sorting and search"},
    %{path: "/orders", name: "Orders", number: 2, badge: "5K", desc: "Every filter type"},
    %{path: "/inventory", name: "Inventory", number: 3, badge: "10K", desc: "Joins and computed"},
    %{path: "/leads", name: "Leads", number: 4, badge: "15K", desc: "Transformers"},
    %{
      path: "/projects",
      name: "Projects",
      number: 5,
      badge: "5K",
      desc: "Cards and bulk actions"
    },
    %{
      path: "/store",
      name: "Storefront",
      number: 6,
      badge: "360",
      desc: "A shop, built on a table"
    },
    %{path: "/live", name: "Live orders", number: 7, badge: "Live", desc: "Real-time rows"},
    %{
      path: "/flagship",
      name: "1M Rows",
      number: 8,
      badge: "1M",
      desc: "Everything, with exports",
      featured: true
    }
  ]

  def demos, do: @demos

  @doc """
  Renders the app layout with navbar navigation.
  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")

  attr(:current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"
  )

  attr(:current_path, :string, default: nil, doc: "the current request path")

  slot(:inner_block, required: true)

  def app(assigns) do
    assigns = assign(assigns, :demos, @demos)

    ~H"""
    <div class="min-h-screen bg-background">
      <!-- Background pattern -->
      <div class="fixed inset-0 bg-dot-pattern opacity-50 pointer-events-none" />
      <div class="fixed inset-0 bg-gradient-mesh pointer-events-none" />

      <!-- Navbar -->
      <nav class="navbar sticky top-0 z-50 border-b border-border/50 bg-background/80">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex items-center justify-between h-16">
            <!-- Logo -->
            <div class="flex items-center gap-3">
              <a href="/" class="flex items-center gap-3 group">
                <div class="flex items-center justify-center w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-500 to-purple-600 text-white font-mono font-bold text-lg shadow-lg group-hover:shadow-cyan-500/25 transition-shadow">
                  LT
                </div>
                <span class="hidden sm:inline font-bold text-lg text-foreground tracking-tight">
                  LiveTable <span class="font-normal text-muted-foreground">Demo</span>
                </span>
              </a>
              <a
                href={live_table_changelog_url()}
                target="_blank"
                rel="noopener noreferrer"
                class="hidden sm:inline-flex items-center rounded-md border border-border/60 bg-muted/40 px-2 py-0.5 text-xs font-medium text-muted-foreground hover:text-foreground hover:bg-accent transition-colors"
                aria-label="View LiveTable changelog"
              >
                v{live_table_version()}
              </a>
            </div>

            <!-- Center nav - Demos dropdown using SutraUI -->
            <div class="hidden sm:flex items-center gap-1">
              <.dropdown_menu id="demos-dropdown" align="center">
                <:trigger>
                  <span class="font-medium">Demos</span>
                </:trigger>
                <.dropdown_label>{length(@demos)} Demos</.dropdown_label>
                <.dropdown_separator />
                <.dropdown_item :for={demo <- @demos}>
                  <a
                    href={demo.path}
                    class={[
                      "flex items-center gap-3 w-full",
                      Map.get(demo, :featured) && "text-cyan-400"
                    ]}
                  >
                    <span class={[
                      "demo-number flex items-center justify-center w-6 h-6 rounded text-xs font-bold",
                      Map.get(demo, :featured) &&
                        "bg-gradient-to-br from-cyan-500 to-purple-600 text-white",
                      !Map.get(demo, :featured) && "bg-cyan-500/10 text-cyan-400"
                    ]}>
                      {demo.number}
                    </span>
                    <span class="flex-1">{demo.name}</span>
                  </a>
                </.dropdown_item>
              </.dropdown_menu>
            </div>

            <!-- Right side -->
            <div class="flex items-center gap-2">
              <a
                href="https://hex.pm/packages/live_table"
                target="_blank"
                rel="noopener noreferrer"
                class="hidden sm:flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium text-muted-foreground hover:text-foreground hover:bg-accent transition-colors"
              >
                <.icon name="lucide-book-open" class="size-4" />
                <span class="hidden md:inline">Docs</span>
              </a>
              <a
                href="https://github.com/gurujada/live_table"
                target="_blank"
                rel="noopener noreferrer"
                class="hidden sm:flex items-center gap-2 px-3 py-2 rounded-lg text-sm font-medium text-muted-foreground hover:text-foreground hover:bg-accent transition-colors"
              >
                <.icon name="lucide-github" class="size-4" />
                <span class="hidden md:inline">GitHub</span>
              </a>
              <div class="w-px h-6 bg-border hidden sm:block" />
              <.theme_switcher id="navbar-theme-toggle" variant="ghost" />
            </div>
          </div>
        </div>
      </nav>

      <!-- Mobile demo nav -->
      <div class="sm:hidden border-b border-border/50 bg-background/60 backdrop-blur-sm overflow-x-auto">
        <div class="flex gap-1 px-4 py-2">
          <a
            :for={demo <- @demos}
            href={demo.path}
            class="flex-shrink-0 flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium bg-muted/50 text-muted-foreground hover:bg-accent hover:text-foreground transition-colors"
          >
            <span class="demo-number">{demo.number}</span>
            <span>{demo.name}</span>
          </a>
        </div>
      </div>

      <!-- Main content -->
      <main class="relative">
        {render_slot(@inner_block)}
      </main>

      <!-- Footer -->
      <footer class="relative border-t border-border/50 bg-background/60 backdrop-blur-sm mt-4">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div class="flex flex-col md:flex-row items-center justify-between gap-4">
            <div class="flex items-center gap-3">
              <div class="flex items-center justify-center w-8 h-8 rounded-lg bg-gradient-to-br from-cyan-500 to-purple-600 text-white font-mono font-bold text-sm">
                LT
              </div>
              <div class="text-sm text-muted-foreground">
                <span class="text-foreground font-medium">LiveTable</span>
                by
                <a
                  href="https://github.com/gurujada"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="text-cyan-400 hover:text-cyan-300 transition-colors"
                >
                  Gurujada
                </a>
              </div>
            </div>
            <div class="flex items-center gap-4 text-sm text-muted-foreground">
              <a
                href="https://hex.pm/packages/live_table"
                target="_blank"
                rel="noopener noreferrer"
                class="hover:text-foreground transition-colors"
              >
                Hex.pm
              </a>
              <span class="text-border">|</span>
              <a
                href="https://github.com/gurujada/live_table"
                target="_blank"
                rel="noopener noreferrer"
                class="hover:text-foreground transition-colors"
              >
                GitHub
              </a>
              <span class="text-border">|</span>
              <a
                href={live_table_changelog_url()}
                target="_blank"
                rel="noopener noreferrer"
                class="hover:text-foreground transition-colors"
              >
                v{live_table_version()}
              </a>
              <span class="text-border">|</span>
              <a
                href="https://github.com/gurujada/livetable_demo"
                target="_blank"
                rel="noopener noreferrer"
                class="hover:text-foreground transition-colors"
              >
                Demo
              </a>
            </div>
          </div>
        </div>
      </footer>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")
  attr(:id, :string, default: "flash-group", doc: "the optional id of flash container")

  def flash_group(assigns) do
    ~H"""
    <div id={@id} class="fixed top-20 right-4 z-50 flex flex-col gap-2" aria-live="polite">
      <.flash_message :if={Phoenix.Flash.get(@flash, :info)} kind={:info} flash={@flash} />
      <.flash_message :if={Phoenix.Flash.get(@flash, :error)} kind={:error} flash={@flash} />

      <div
        id="client-error"
        class="hidden phx-client-error:flex items-center gap-3 px-4 py-3 rounded-xl bg-destructive text-destructive-foreground shadow-lg"
      >
        <.icon name="lucide-wifi-off" class="size-5" />
        <div>
          <p class="font-semibold">{gettext("We can't find the internet")}</p>
          <p class="text-sm flex items-center gap-1 opacity-90">
            {gettext("Attempting to reconnect")}
            <.icon name="lucide-loader-circle" class="size-3 animate-spin" />
          </p>
        </div>
      </div>

      <div
        id="server-error"
        class="hidden phx-server-error:flex items-center gap-3 px-4 py-3 rounded-xl bg-destructive text-destructive-foreground shadow-lg"
      >
        <.icon name="lucide-alert-triangle" class="size-5" />
        <div>
          <p class="font-semibold">{gettext("Something went wrong!")}</p>
          <p class="text-sm flex items-center gap-1 opacity-90">
            {gettext("Attempting to reconnect")}
            <.icon name="lucide-loader-circle" class="size-3 animate-spin" />
          </p>
        </div>
      </div>
    </div>
    """
  end

  attr(:kind, :atom, required: true)
  attr(:flash, :map, required: true)

  defp flash_message(assigns) do
    ~H"""
    <div
      class={[
        "flex items-center gap-3 px-4 py-3 rounded-xl shadow-lg backdrop-blur-sm",
        @kind == :info && "bg-primary/90 text-primary-foreground",
        @kind == :error && "bg-destructive/90 text-destructive-foreground"
      ]}
      role="alert"
    >
      <.icon name={if @kind == :info, do: "lucide-info", else: "lucide-circle-alert"} class="size-5" />
      <p class="font-medium">{Phoenix.Flash.get(@flash, @kind)}</p>
      <button
        type="button"
        class="ml-auto p-1.5 rounded-lg hover:bg-white/20 transition-colors"
        phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> JS.hide(to: "#flash-group")}
      >
        <.icon name="lucide-x" class="size-4" />
      </button>
    </div>
    """
  end

  @doc """
  The frame around every demo: its number, title and description, one thing to try, and the
  demo with a small switch to its source.
  """
  attr(:path, :string, required: true)
  attr(:title, :string, required: true)
  attr(:rows, :string, required: true)
  attr(:try, :string, default: nil)
  attr(:source, :map, required: true, doc: "the LiveView's highlighted source, file and length")
  slot(:intro, required: true)
  slot(:inner_block, required: true)

  def demo(assigns) do
    index = Enum.find_index(@demos, &(&1.path == assigns.path))

    assigns =
      assign(assigns,
        demo: Enum.at(@demos, index),
        prev: index > 0 && Enum.at(@demos, index - 1),
        next: Enum.at(@demos, index + 1)
      )

    ~H"""
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="mb-6">
        <div class="flex items-center gap-4 mb-3">
          <span class={[
            "demo-number flex items-center justify-center w-10 h-10 rounded-xl font-bold text-lg",
            @demo[:featured] &&
              "bg-gradient-to-br from-cyan-500 to-purple-600 text-white shadow-lg shadow-cyan-500/25",
            !@demo[:featured] && "bg-cyan-500/10 text-cyan-400"
          ]}>
            {@demo.number}
          </span>
          <h1 class="text-3xl font-bold text-foreground">{@title}</h1>
          <span class="hidden sm:inline-flex rounded-md bg-muted/60 px-2 py-0.5 font-mono text-xs text-muted-foreground">
            {@rows}
          </span>
        </div>
        <p class="text-muted-foreground text-lg max-w-3xl">{render_slot(@intro)}</p>
        <p :if={@try} class="mt-3 flex items-start gap-2 text-sm text-foreground/90">
          <.icon name="lucide-sparkles" class="mt-0.5 size-4 shrink-0 text-cyan-400" />
          {@try}
        </p>
      </div>

      <div class="mb-2 flex justify-end">
        <div class="inline-flex rounded-md border border-border/60 p-0.5 text-xs" role="tablist">
          <button
            id="tab-demo"
            type="button"
            role="tab"
            aria-selected="true"
            class="rounded px-2.5 py-1 text-muted-foreground aria-selected:bg-muted aria-selected:text-foreground"
            phx-click={show_tab("demo")}
          >
            Demo
          </button>
          <button
            id="tab-code"
            type="button"
            role="tab"
            aria-selected="false"
            class="inline-flex items-center gap-1 rounded px-2.5 py-1 text-muted-foreground aria-selected:bg-muted aria-selected:text-foreground"
            phx-click={show_tab("code")}
          >
            <.icon name="lucide-code" class="size-3.5" /> Code
          </button>
        </div>
      </div>

      <div id="pane-demo">{render_slot(@inner_block)}</div>

      <div id="pane-code" class="hidden">
        <.code_window
          file={@source.file}
          href={"https://github.com/gurujada/livetable_demo/blob/master/#{@source.file}"}
          lines={@source.lines}
        >
          {Phoenix.HTML.raw(@source.html)}
        </.code_window>
      </div>

      <nav class="mt-12 flex justify-between gap-4 border-t border-border/50 pt-6 text-sm">
        <a :if={@prev} href={@prev.path} class="group">
          <span class="block text-muted-foreground">Previous</span>
          <span class="font-semibold text-foreground group-hover:text-cyan-400">{@prev.name}</span>
        </a>
        <span :if={!@prev}></span>
        <a :if={@next} href={@next.path} class="group text-right">
          <span class="block text-muted-foreground">Next</span>
          <span class="font-semibold text-foreground group-hover:text-cyan-400">{@next.name}</span>
        </a>
      </nav>
    </div>
    """
  end

  defp show_tab(tab) do
    other = if tab == "demo", do: "code", else: "demo"

    JS.show(to: "#pane-#{tab}")
    |> JS.hide(to: "#pane-#{other}")
    |> JS.set_attribute({"aria-selected", "true"}, to: "#tab-#{tab}")
    |> JS.set_attribute({"aria-selected", "false"}, to: "#tab-#{other}")
  end

  @doc "A dark editor window around highlighted code, as on the home page."
  attr(:file, :string, required: true)
  attr(:lines, :integer, default: nil)
  attr(:href, :string, default: nil, doc: "the full file, when the window shows an excerpt")
  slot(:inner_block, required: true)

  def code_window(assigns) do
    ~H"""
    <div class="code-window relative rounded-2xl overflow-hidden border border-border/50 bg-[#0d1117] shadow-2xl">
      <div class="flex items-center justify-between gap-3 px-4 py-3 border-b border-white/10 bg-white/[0.02]">
        <div class="flex min-w-0 items-center gap-3">
          <div class="flex shrink-0 gap-1.5">
            <div class="w-3 h-3 rounded-full bg-[#ff5f56]" />
            <div class="w-3 h-3 rounded-full bg-[#ffbd2e]" />
            <div class="w-3 h-3 rounded-full bg-[#27ca40]" />
          </div>
          <span class="truncate text-xs text-gray-500 font-mono">{@file}</span>
        </div>
        <a
          :if={@href}
          href={@href}
          target="_blank"
          rel="noopener noreferrer"
          class="shrink-0 text-xs text-gray-400 hover:text-cyan-400"
        >
          Full file, {@lines} lines
        </a>
      </div>
      <div class="p-6 overflow-x-auto">{render_slot(@inner_block)}</div>
    </div>
    """
  end
end
