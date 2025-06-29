defmodule DemoWeb.Filters.RangeLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Weather.Record
  alias LiveTable.Range

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Range Filters")}
  end

  def fields do
    [
      location: %{
        label: "Location",
        sortable: true
      },
      temperature: %{
        label: "Temperature (°C)",
        sortable: true
      },
      humidity: %{
        label: "Humidity (%)",
        sortable: true
      },
      wind_speed: %{
        label: "Wind Speed (km/h)",
        sortable: true
      },
      precipitation: %{
        label: "Precipitation (mm)",
        sortable: true
      },
      weather_condition: %{
        label: "Condition",
        sortable: true
      },
      recorded_at: %{
        label: "Recorded At",
        sortable: true
      }
    ]
  end

  def filters do
    [
      temperature:
        Range.new(:temperature, "temp_range", %{
          type: :number,
          label: "Temperature Range",
          unit: "°C",
          min: -20,
          max: 50,
          step: 1,
          slider_options: %{
            tooltips: true
          }
        }),
      humidity:
        Range.new(:humidity, "humidity_range", %{
          type: :number,
          label: "Humidity Range",
          unit: "%",
          min: 0,
          max: 100,
          step: 5
        }),
      wind_speed:
        Range.new(:wind_speed, "wind_range", %{
          type: :number,
          label: "Wind Speed Range",
          unit: "km/h",
          min: 0,
          max: 100,
          step: 1
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
              <div class="text-4xl">📊</div>
              <div>
                <h1 class="text-3xl font-bold">Range Filters</h1>
                <p class="opacity-70">Interactive slider controls for numeric data filtering</p>
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
                <h3 class="font-bold">Use the range sliders:</h3>
                <div class="text-sm">
                  Drag slider handles to filter by temperature (-20°C to 50°C), humidity (0-100%), and wind speed
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
