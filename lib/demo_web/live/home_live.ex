defmodule DemoWeb.HomeLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Live.Order

  alias Demo.Live.Feed

  # The hero's table is a real LiveTable on the live order feed, with its controls removed.
  def mount(_params, _session, socket) do
    socket = LiveTable.subscribe(socket, Demo.PubSub, Feed.topic())
    if connected?(socket), do: Feed.watch()
    {:ok, socket}
  end

  def handle_info({:stats, _stats}, socket), do: {:noreply, socket}

  def fields do
    [
      id: %{label: "ID", hidden: true},
      number: %{label: "Order", component: &fresh/1},
      customer: %{label: "Customer"},
      amount: %{label: "Amount", renderer: &money/1},
      status: %{label: "Status", component: &fresh/1},
      inserted_at: %{label: "Placed", hidden: true},
      updated_at: %{label: "Updated", hidden: true}
    ]
  end

  def filters, do: []

  def table_options do
    %{
      pagination: %{sizes: [6], default_size: 6},
      sorting: %{default_sort: [inserted_at: :desc]},
      exports: %{enabled: false},
      custom_header: {__MODULE__, :none},
      custom_footer: {__MODULE__, :none}
    }
  end

  def none(assigns), do: ~H""

  defp fresh(assigns) do
    ~H"""
    <span class={[
      "px-1 -mx-1 py-0.5",
      DateTime.diff(DateTime.utc_now(), @record.updated_at, :millisecond) < 2500 && "is-fresh"
    ]}>
      <.pill :if={@value in Demo.Live.Order.statuses()} value={@value} />
      <span :if={@value not in Demo.Live.Order.statuses()} class="font-semibold">#{@value}</span>
    </span>
    """
  end

  @code """
  defmodule MyAppWeb.OrdersLive do
    use MyAppWeb, :live_view
    use LiveTable.LiveResource, schema: MyApp.Order

    def mount(_params, _session, socket) do
      # Rows update in every open window when you call LiveTable.broadcast/3.
      {:ok, LiveTable.subscribe(socket, MyApp.PubSub, "orders")}
    end

    def fields do
      [
        number: %{label: "Order", searchable: true},
        customer: %{label: "Customer", sortable: true, searchable: true},
        amount: %{label: "Amount", sortable: true},
        status: %{label: "Status"}
      ]
    end

    def filters do
      [
        big: Boolean.new(:amount, "big", %{
          label: "Big orders",
          condition: dynamic([o], o.amount > 10_000)
        })
      ]
    end

    def render(assigns) do
      ~H\"\"\"
      <.live_table fields={fields()} filters={filters()} options={@options} streams={@streams} />
      \"\"\"
    end
  end
  """

  @code_html Makeup.highlight(@code)

  @cards %{
    "/contacts" =>
      {"A table straight from an Ecto schema. Sorting, search and pagination.",
       ["Sorting", "Search"]},
    "/orders" =>
      {"Select, search-as-you-type, range and toggle filters, all in the URL.",
       ["All filters", "Shareable URLs"]},
    "/inventory" =>
      {"Sort and search across joined tables and computed columns.", ["Joins", "Computed"]},
    "/leads" =>
      {"Filters that are functions, for logic a checkbox can't express.", ["Transformers"]},
    "/projects" =>
      {"Cards with infinite scroll. Select some and act on them at once.",
       ["Cards", "Bulk actions"]},
    "/store" =>
      {"A shop page with a sidebar and product cards. Still a LiveTable.",
       ["Custom controls", "Cards"]},
    "/live" =>
      {"Orders arrive and change in every open window, with a dashboard.",
       ["Real-time", "Bulk actions"]},
    "/flagship" =>
      {"Every feature on a million rows, with CSV and PDF export.", ["1M rows", "Exports"]}
  }

  attr :demo, :map, required: true

  defp demo_card(assigns) do
    {description, features} = @cards[assigns.demo.path]
    assigns = assign(assigns, description: description, features: features)

    ~H"""
    <a
      href={@demo.path}
      class={[
        "group relative flex flex-col p-5 rounded-xl border transition-all duration-300 overflow-hidden h-full",
        @demo[:featured] &&
          "border-cyan-500/50 bg-gradient-to-br from-cyan-500/10 via-card to-purple-500/5 hover:border-cyan-400/70 hover:shadow-lg hover:shadow-cyan-500/20",
        !@demo[:featured] && "border-border/60 bg-card/50 hover:border-cyan-500/40 hover:bg-card/80"
      ]}
    >
      <div class="flex items-center gap-3 mb-3">
        <span class={[
          "flex items-center justify-center w-8 h-8 rounded-lg text-sm font-bold transition-all duration-300 font-mono",
          @demo[:featured] && "bg-gradient-to-br from-cyan-500 to-purple-600 text-white shadow-md",
          !@demo[:featured] &&
            "bg-muted text-muted-foreground group-hover:bg-cyan-500/20 group-hover:text-cyan-400"
        ]}>
          {@demo.number}
        </span>
        <h3 class="font-display font-semibold text-foreground transition-colors group-hover:text-cyan-400">
          {@demo.name}
        </h3>
        <span class="ml-auto px-2 py-0.5 text-xs font-mono font-bold rounded bg-cyan-500/10 text-cyan-400">
          {@demo.badge}
        </span>
      </div>
      <p class="text-sm text-muted-foreground leading-relaxed mb-3 flex-1">{@description}</p>
      <div class="flex flex-wrap gap-1.5">
        <span
          :for={feature <- @features}
          class="px-2 py-0.5 text-xs rounded bg-muted/50 text-muted-foreground/80 font-medium"
        >
          {feature}
        </span>
      </div>
    </a>
    """
  end

  attr :icon, :string, required: true
  attr :title, :string, required: true
  attr :color, :string, default: "cyan"
  attr :class, :string, default: ""
  slot :inner_block, required: true
  slot :tags

  defp feature(assigns) do
    ~H"""
    <div class={[
      "p-6 rounded-2xl border border-border/50 bg-card/30 hover:bg-card/50 transition-all group",
      @color == "cyan" && "hover:border-cyan-500/30 hover:shadow-lg hover:shadow-cyan-500/10",
      @color == "purple" && "hover:border-purple-500/30 hover:shadow-lg hover:shadow-purple-500/10",
      @color == "amber" && "hover:border-amber-500/30 hover:shadow-lg hover:shadow-amber-500/10",
      @color == "green" && "hover:border-green-500/30 hover:shadow-lg hover:shadow-green-500/10",
      @color == "pink" && "hover:border-pink-500/30 hover:shadow-lg hover:shadow-pink-500/10",
      @class
    ]}>
      <div class="flex items-center gap-3 mb-3">
        <div class={[
          "p-2.5 rounded-xl transition-colors",
          @color == "cyan" && "bg-cyan-500/10 text-cyan-400 group-hover:bg-cyan-500/20",
          @color == "purple" && "bg-purple-500/10 text-purple-400 group-hover:bg-purple-500/20",
          @color == "amber" && "bg-amber-500/10 text-amber-400 group-hover:bg-amber-500/20",
          @color == "green" && "bg-green-500/10 text-green-400 group-hover:bg-green-500/20",
          @color == "pink" && "bg-pink-500/10 text-pink-400 group-hover:bg-pink-500/20"
        ]}>
          <.icon name={@icon} class="size-5" />
        </div>
        <h3 class="font-semibold text-foreground">{@title}</h3>
      </div>
      <p class="text-sm text-muted-foreground">{render_slot(@inner_block)}</p>
      <div :if={@tags != []} class="mt-4 flex flex-wrap gap-2">
        <span
          :for={tag <- @tags}
          class="px-2 py-1 text-xs rounded bg-muted/50 text-muted-foreground"
        >
          {render_slot(tag)}
        </span>
      </div>
    </div>
    """
  end

  def render(assigns) do
    assigns = assign(assigns, demos: Layouts.demos(), code_html: @code_html)

    ~H"""
    <Layouts.app flash={@flash}>
      <div class="relative">
        <section class="relative overflow-hidden">
          <div class="absolute top-20 left-1/4 w-96 h-96 bg-cyan-500/20 rounded-full blur-3xl animate-float" />
          <div class="absolute top-40 right-1/4 w-80 h-80 bg-purple-500/15 rounded-full blur-3xl animate-float delay-200" />
          <div class="absolute bottom-0 left-1/2 w-72 h-72 bg-amber-500/10 rounded-full blur-3xl animate-float delay-400" />

          <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-16">
            <div class="text-center">
              <div class="animate-on-load animate-fade-in inline-flex items-center gap-2 px-4 py-2 rounded-full bg-cyan-500/10 border border-cyan-500/20 text-cyan-400 text-sm font-medium mb-8">
                <span class="flex h-2 w-2 rounded-full bg-cyan-400 animate-pulse" />
                Phoenix LiveView Library
              </div>

              <h1 class="animate-on-load animate-fade-in delay-100 text-5xl sm:text-6xl lg:text-7xl font-extrabold tracking-tight mb-6">
                <span class="text-foreground">Real-time</span>
                <br />
                <span class="text-gradient">DataTables</span>
              </h1>

              <p class="animate-on-load animate-fade-in delay-200 text-xl sm:text-2xl text-muted-foreground max-w-3xl mx-auto mb-12 leading-relaxed">
                Build powerful, scalable data tables with <span class="text-cyan-400 font-semibold">sorting</span>, <span class="text-purple-400 font-semibold">filtering</span>, <span class="text-amber-400 font-semibold">bulk actions</span>, and updates that reach every open window.
              </p>

              <div class="animate-on-load animate-fade-in delay-300 flex flex-wrap justify-center gap-4">
                <a
                  href="/live"
                  class="btn-glow inline-flex items-center gap-2 px-8 py-4 rounded-xl bg-gradient-to-r from-cyan-500 to-purple-600 text-white font-semibold text-lg shadow-lg shadow-cyan-500/25 hover:shadow-cyan-500/40 transition-all hover:scale-105"
                >
                  <.icon name="lucide-radio" class="size-5" /> See it live
                </a>
                <a
                  href="/flagship"
                  class="inline-flex items-center gap-2 px-8 py-4 rounded-xl border border-border bg-card/50 text-foreground font-semibold text-lg hover:bg-card hover:border-cyan-500/50 transition-all"
                >
                  <.icon name="lucide-play" class="size-5" /> Try 1M Rows
                </a>
              </div>
            </div>

            <div class="animate-on-load animate-fade-in delay-400 relative mt-16 mx-auto max-w-4xl rounded-2xl border border-border/60 bg-card/60 p-4 shadow-2xl backdrop-blur-sm sm:p-6">
              <div class="flex flex-wrap items-center justify-between gap-2">
                <div class="flex items-center gap-2 text-sm font-medium text-foreground">
                  <span class="flex h-2 w-2 rounded-full bg-green-400 animate-pulse" />
                  Orders, right now
                </div>
                <a href="/live" class="text-sm text-cyan-400 hover:text-cyan-300">
                  Open the live demo
                </a>
              </div>
              <p class="mt-1 text-sm text-muted-foreground">
                A real LiveTable. New orders arrive and change while you watch.
              </p>
              <div class="[&_.mt-8]:mt-3">
                <.live_table
                  fields={fields()}
                  filters={filters()}
                  options={@options}
                  streams={@streams}
                />
              </div>
            </div>
          </div>
        </section>

        <section class="relative py-20">
          <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12">
              <h2 class="text-3xl sm:text-4xl font-bold text-foreground mb-4">
                {length(@demos)} demos to play with
              </h2>
              <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
                Each one is a single LiveView, with its source a click away.
              </p>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              <.demo_card :for={demo <- @demos} demo={demo} />
            </div>
          </div>
        </section>

        <section class="relative py-24 overflow-hidden">
          <div class="absolute inset-0 bg-gradient-to-b from-transparent via-cyan-500/[0.02] to-transparent" />
          <div class="relative max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
              <span class="inline-block px-3 py-1 mb-4 text-xs font-semibold tracking-wider uppercase rounded-full bg-cyan-500/10 text-cyan-400 border border-cyan-500/20">
                Features
              </span>
              <h2 class="text-3xl sm:text-4xl font-bold text-foreground mb-4">Everything You Need</h2>
              <p class="text-lg text-muted-foreground max-w-xl mx-auto">
                Production-ready features that work out of the box.
              </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <.feature icon="lucide-radio" title="Real-time Rows" class="md:row-span-2">
                Subscribe in mount and broadcast where your data changes. Every open table
                updates in place, and only the rows that changed are sent to the browser.
                <:tags>PubSub</:tags>
                <:tags>Changed rows only</:tags>
                <:tags>No polling</:tags>
              </.feature>
              <.feature icon="lucide-sliders-horizontal" title="Smart Filters" color="purple">
                Toggles, ranges, selects with search-as-you-type, and query transformers. All in the URL.
              </.feature>
              <.feature icon="lucide-list-checks" title="Bulk Actions" color="amber">
                Select rows, or every row matching the filters. Your handler gets one Ecto query.
              </.feature>
              <.feature icon="lucide-git-merge" title="Ecto Joins">
                Sort, search and filter across associations and computed columns.
              </.feature>
              <.feature icon="lucide-download" title="CSV & PDF Export" color="green">
                Exactly what's filtered, streamed straight to the browser. No job queue.
              </.feature>
              <.feature icon="lucide-paintbrush" title="Your Components" color="pink">
                Cells, cards, controls and empty states are yours. The storefront is a table too.
              </.feature>
              <.feature icon="lucide-zap" title="Built for Performance" class="md:col-span-2">
                Sorting, filtering and pagination run in the database, so a million rows page as
                quickly as a hundred.
                <:tags>DB-level pagination</:tags>
                <:tags>1M-row demo</:tags>
              </.feature>
            </div>
          </div>
        </section>

        <section class="relative py-20">
          <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-10">
              <span class="inline-block px-3 py-1 mb-4 text-xs font-semibold tracking-wider uppercase rounded-full bg-purple-500/10 text-purple-400 border border-purple-500/20">
                Delightful DX
              </span>
              <h2 class="text-3xl sm:text-4xl font-bold text-foreground mb-4">
                Minimal Code, Maximum Power
              </h2>
              <p class="text-lg text-muted-foreground">
                A searchable, filterable, paginated table that stays in sync across every window.
              </p>
            </div>
            <div class="relative group">
              <div class="absolute -inset-1 bg-gradient-to-r from-cyan-500/20 via-purple-500/20 to-cyan-500/20 rounded-2xl blur-xl opacity-50 group-hover:opacity-75 transition-opacity" />
              <Layouts.code_window file="lib/my_app_web/live/orders_live.ex">
                {Phoenix.HTML.raw(@code_html)}
              </Layouts.code_window>
            </div>
          </div>
        </section>

        <section class="relative py-20">
          <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <div class="relative rounded-3xl overflow-hidden border border-cyan-500/20 bg-gradient-to-br from-cyan-500/10 via-purple-500/5 to-amber-500/10 p-8 sm:p-12">
              <div class="absolute top-0 left-1/2 -translate-x-1/2 w-1/2 h-1 bg-gradient-to-r from-transparent via-cyan-500 to-transparent" />
              <h2 class="text-3xl sm:text-4xl font-bold text-foreground mb-4">
                Ready to build powerful tables?
              </h2>
              <p class="text-lg text-muted-foreground mb-8">
                Add LiveTable to your Phoenix project in minutes.
              </p>
              <div class="inline-flex max-w-full items-center gap-3 overflow-x-auto px-6 py-3 rounded-xl bg-muted/50 border border-border font-mono text-sm mb-8">
                <span class="text-cyan-400 whitespace-nowrap">
                  {"{:live_table, \"~> #{Layouts.live_table_version()}\"}"}
                </span>
              </div>
              <div class="flex flex-wrap justify-center gap-4">
                <a
                  href="https://hexdocs.pm/live_table"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-cyan-500 text-white font-semibold hover:bg-cyan-600 transition-colors"
                >
                  <.icon name="lucide-book-open" class="size-5" /> Read the Docs
                </a>
                <a
                  href="https://github.com/gurujada/live_table"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="inline-flex items-center gap-2 px-6 py-3 rounded-xl border border-border bg-card text-foreground font-semibold hover:bg-accent transition-colors"
                >
                  <.icon name="lucide-github" class="size-5" /> Star on GitHub
                </a>
              </div>
            </div>
          </div>
        </section>
      </div>
    </Layouts.app>
    """
  end
end
