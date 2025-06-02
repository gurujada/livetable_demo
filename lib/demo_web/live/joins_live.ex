defmodule DemoWeb.JoinsLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Events.Event

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(data_provider: {Demo.Events, :list_events, []})
      |> assign(page_title: "Table Joins")

    {:ok, socket}
  end

  def fields do
    [
      title: %{
        label: "Event Title",
        sortable: true
      },
      starts_at: %{
        label: "Start Time",
        sortable: true
      },
      # Registration count with status breakdown
      total_registrations: %{
        label: "Total Registrations",
        sortable: true,
        computed: dynamic([_, registrations: r], count(r.id))
      },
      # for associated sort, need to write as computed

      confirmed_count: %{
        label: "Confirmed",
        sortable: true,
        computed: dynamic([resource: e, registrations: r],
          count(fragment("CASE WHEN ? = 'confirmed' THEN 1 END", r.status)))
      },
      waitlist_count: %{
        label: "Waitlisted",
        sortable: true,
        computed: dynamic([resource: e, registrations: r],
          count(fragment("CASE WHEN ? = 'waitlisted' THEN 1 END", r.status)))
      },
      # Latest registration
      latest_registration: %{
        label: "Latest Registration",
        sortable: true,
        computed: dynamic([resource: e, registrations: r],
          fragment("MAX(?)", r.inserted_at))
      }
    ]
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-primary/5 via-base-100 to-secondary/5">
      <!-- Page Header -->
      <div class="bg-base-100 border-b border-base-200">
        <div class="container mx-auto px-6 py-8">
          <div class="flex items-center gap-4">
            <div class="text-4xl">🔗</div>
            <div>
              <h1 class="text-3xl font-bold">Table Joins</h1>
              <p class="opacity-70">Complex database relationships with efficient querying</p>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Quick Info -->
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
              <h3 class="font-bold">Database relationships demo:</h3>
              <div class="text-sm">
                Display related data from multiple tables with optimized joins and computed fields
              </div>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Table Section -->
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
    """
  end
end
