defmodule DemoWeb.Filters.DateRangeLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Events.Event
  alias LiveTable.Range

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Date Range Filters")}
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
      registration_deadline: %{
        label: "Registration Deadline",
        sortable: true
      },
      status: %{
        label: "Status",
        sortable: true
      },
      max_participants: %{
        label: "Capacity",
        sortable: true
      }
    ]
  end

  def filters do
    now = DateTime.utc_now()
    today = Date.utc_today()

    [
      # DateTime range filter
      event_time:
        Range.new(:starts_at, "event_time", %{
          type: :datetime,
          label: "Event Time Range",
          default_min: DateTime.add(now, -30, :day),
          default_max: DateTime.add(now, 30, :day),
          # 1 hour in seconds
          step: 3600
        }),

      # Date range filter
      deadline:
        Range.new(:registration_deadline, "deadline", %{
          type: :date,
          label: "Registration Deadline Range",
          default_min: Date.add(today, -7),
          default_max: Date.add(today, 30)
        })
    ]
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="min-h-screen bg-gradient-to-br from-primary/5 via-base-100 to-secondary/5">
        <div class="bg-base-100 border-b border-base-200">
          <div class="container mx-auto px-6 py-8">
            <div class="flex items-center gap-4">
              <div class="text-4xl">📅</div>
              <div>
                <h1 class="text-3xl font-bold">Date Range Filters</h1>
                <p class="opacity-70">Calendar controls for filtering by date and time periods</p>
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
                <h3 class="font-bold">Use the date pickers:</h3>
                <div class="text-sm">
                  Select date ranges for event times and registration deadlines using the calendar controls
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
