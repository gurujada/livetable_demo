defmodule DemoWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is rendered as component
  in regular views and live views.
  """
  use DemoWeb, :html

  embed_templates("layouts/*")

  @demos [
    %{path: "/contacts", name: "Contacts", number: 1, badge: "500", desc: "Basic table"},
    %{path: "/tasks", name: "Tasks", number: 2, badge: "1K", desc: "Boolean filters"},
    %{path: "/demo-employees", name: "Employees", number: 3, badge: "2K", desc: "Range filters"},
    %{path: "/products-simple", name: "Products", number: 4, badge: "3K", desc: "Select filters"},
    %{path: "/orders", name: "Orders", number: 5, badge: "5K", desc: "Combined filters"},
    %{path: "/invoices", name: "Invoices", number: 6, badge: "8K", desc: "Table joins"},
    %{path: "/inventory", name: "Inventory", number: 7, badge: "10K", desc: "Computed fields"},
    %{path: "/leads", name: "Leads", number: 8, badge: "15K", desc: "Advanced filters"},
    %{path: "/projects", name: "Projects", number: 9, badge: "5K", desc: "Card mode"},
    %{
      path: "/flagship",
      name: "1M Rows",
      number: 10,
      badge: "1M",
      desc: "All features",
      featured: true
    }
  ]

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
            <a href="/" class="flex items-center gap-3 group">
              <div class="flex items-center justify-center w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-500 to-purple-600 text-white font-mono font-bold text-lg shadow-lg group-hover:shadow-cyan-500/25 transition-shadow">
                LT
              </div>
              <span class="hidden sm:inline font-bold text-lg text-foreground tracking-tight">
                LiveTable <span class="font-normal text-muted-foreground">Demo</span>
              </span>
            </a>
            
    <!-- Center nav - Demos dropdown using SutraUI -->
            <div class="hidden sm:flex items-center gap-1">
              <.dropdown_menu id="demos-dropdown" align="center">
                <:trigger>
                  <span class="font-medium">Demos</span>
                </:trigger>
                <.dropdown_label>10 Progressive Demos</.dropdown_label>
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
  Renders a page header for demo pages.
  """
  attr(:number, :integer, required: true, doc: "Demo number (1-10)")
  attr(:title, :string, required: true, doc: "Page title")
  attr(:rows, :string, required: true, doc: "Number of rows badge text")
  attr(:description, :string, required: true, doc: "Page description")
  attr(:featured, :boolean, default: false, doc: "Whether this is the featured flagship demo")

  def page_header(assigns) do
    ~H"""
    <div class="mb-8">
      <div class="flex items-center gap-4 mb-3">
        <span class={[
          "demo-number flex items-center justify-center w-10 h-10 rounded-xl font-bold text-lg",
          @featured &&
            "bg-gradient-to-br from-cyan-500 to-purple-600 text-white shadow-lg shadow-cyan-500/25",
          !@featured && "bg-cyan-500/10 text-cyan-400"
        ]}>
          {@number}
        </span>
        <h1 class="text-3xl font-bold text-foreground">{@title}</h1>
      </div>
      <p class="text-muted-foreground text-lg">{@description}</p>
    </div>
    """
  end
end
