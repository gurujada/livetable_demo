defmodule DemoWeb.SearchLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.Catalog.Product

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Search Demo")}
  end

  def fields do
    [
      name: %{
        label: "Product Name",
        sortable: true,
        searchable: true
      },
      description: %{
        label: "Description",
        sortable: false,
        searchable: true
      },
      price: %{
        label: "Price",
        sortable: true,
        searchable: false
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
            <div class="text-4xl">🔍</div>
            <div>
              <h1 class="text-3xl font-bold">Search Demo</h1>
              <p class="opacity-70">Real-time full-text search across multiple columns</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Info -->
      <div class="bg-base-200/50 py-4">
        <div class="container mx-auto px-6">
          <div class="bg-info/10 border border-info/20 rounded-lg p-4 flex items-start gap-3">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-info flex-shrink-0 w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
            <div>
              <h3 class="font-bold">Try searching:</h3>
              <div class="text-sm">
                Type "laptop", "gaming", "wireless", or partial words like "blu" to see instant results
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

  def table_options() do
    %{
      exports: %{enabled: false}
    }
  end
end