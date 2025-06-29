defmodule DemoWeb.PostLive.Index do
  use DemoWeb, :live_view

  use LiveTable.LiveResource

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(data_provider: {Demo.Timeline, :list_posts, []})
      |> assign(page_title: "Timeline Posts")

    {:ok, socket}
  end

  def fields do
    [
      id: %{label: "ID", sortable: true},
      body: %{label: "Body", sortable: true},
      inserted_at: %{label: "Inserted At", sortable: false}
    ]
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="min-h-screen bg-gradient-to-br from-primary/5 via-base-100 to-secondary/5">
        <div class="bg-base-100 border-b border-base-200">
          <div class="container mx-auto px-6 py-8">
            <div class="flex items-center gap-4">
              <div class="text-4xl">📝</div>
              <div>
                <h1 class="text-3xl font-bold">Timeline Posts</h1>
                <p class="opacity-70">Custom data provider integration example</p>
              </div>
            </div>
          </div>
        </div>

        <div class="bg-base-200/50 py-4">
          <div class="container mx-auto px-6">
            <div class="bg-info/10 border border-info/20 rounded-lg p-4 flex items-start gap-3">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                class="stroke-info flex-shrink-0 w-6 h-6"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                >
                </path>
              </svg>
              <div>
                <h3 class="font-bold">Custom data provider demo:</h3>
                <div class="text-sm">
                  This table uses a custom function instead of an Ecto schema - perfect for APIs, CSV files, or external data sources
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="container mx-auto px-6 py-8">
          <div class="bg-base-100 rounded-lg shadow-lg overflow-hidden">
            <div class="p-6">
              <.live_table
                fields={fields()}
                filters={filters()}
                options={@options}
                streams={@streams}
                class="w-full"
              />
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
