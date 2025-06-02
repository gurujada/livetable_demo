defmodule DemoWeb.CustomBadgeLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource, schema: Demo.HR.Employee
  alias LiveTable.Boolean

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Custom Rendering")}
  end

  def fields do
    [
      id: %{
        label: "ID",
        sortable: true
      },
      name: %{
        label: "Name",
        sortable: true
      },
      email: %{
        label: "Email",
        sortable: true
      },
      department: %{
        label: "Department",
        sortable: true,
        renderer: &department_badge/1
      },
      level: %{
        label: "Level",
        sortable: true,
        renderer: &level_badge/1
      },
      active: %{
        label: "Status",
        sortable: false,
        renderer: &status_badge/1
      }
    ]
  end

  def filters do
    [
      active:
        Boolean.new(:active, "active", %{
          label: "Active Employees Only",
          condition: dynamic([e], e.active == true)
        }),
      senior:
        Boolean.new(:level, "senior", %{
          label: "Senior Level+",
          condition: dynamic([e], e.level in ["senior", "lead"])
        })
    ]
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-primary/5 via-base-100 to-secondary/5">

      <div class="bg-base-100 border-b border-base-200">
        <div class="container mx-auto px-6 py-8">
          <div class="flex items-center gap-4">
            <div class="text-4xl">🎨</div>
            <div>
              <h1 class="text-3xl font-bold">Custom Badges</h1>
              <p class="opacity-70">Beautiful custom column renderers and status indicators</p>
            </div>
          </div>
        </div>
      </div>

    
      <div class="bg-base-200/50 py-4">
        <div class="container mx-auto px-6">
          <div class="alert shadow-sm">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="stroke-info flex-shrink-0 w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <div>
              <h3 class="font-bold">Custom column renderers:</h3>
              <div class="text-sm">
                See how custom functions transform plain data into beautiful badges and status indicators
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
    """
  end

  # Custom renderer functions
  def status_badge(true) do
    assigns = "Active"
    ~H"""
    <span class="badge badge-success gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def status_badge(false) do
    assigns = "Inactive"
    ~H"""
    <span class="badge badge-error gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def department_badge("Engineering") do
    assigns = "Engineering"
    ~H"""
    <span class="badge badge-primary gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path d="M12.316 3.051a1 1 0 01.633 1.265l-4 12a1 1 0 11-1.898-.632l4-12a1 1 0 011.265-.633zM5.707 6.293a1 1 0 010 1.414L3.414 10l2.293 2.293a1 1 0 11-1.414 1.414l-3-3a1 1 0 010-1.414l3-3a1 1 0 011.414 0zm8.586 0a1 1 0 011.414 0l3 3a1 1 0 010 1.414l-3 3a1 1 0 11-1.414-1.414L16.586 10l-2.293-2.293a1 1 0 010-1.414z"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def department_badge("Marketing") do
    assigns = "Marketing"
    ~H"""
    <span class="badge badge-secondary gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M18 13V5a2 2 0 00-2-2H4a2 2 0 00-2 2v8a2 2 0 002 2h3l3 3 3-3h3a2 2 0 002-2zM5 7a1 1 0 011-1h8a1 1 0 110 2H6a1 1 0 01-1-1zm1 3a1 1 0 100 2h3a1 1 0 100-2H6z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def department_badge("Finance") do
    assigns = "Finance"
    ~H"""
    <span class="badge badge-accent gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path d="M8.433 7.418c.155-.103.346-.196.567-.267v1.698a2.305 2.305 0 01-.567-.267C8.07 8.34 8 8.114 8 8c0-.114.07-.34.433-.582zM11 12.849v-1.698c.22.071.412.164.567.267.364.243.433.468.433.582 0 .114-.07.34-.433.582a2.305 2.305 0 01-.567.267z"/>
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-13a1 1 0 10-2 0v.092a4.535 4.535 0 00-1.676.662C6.602 6.234 6 7.009 6 8c0 .99.602 1.765 1.324 2.246.48.32 1.054.545 1.676.662v1.941c-.391-.127-.68-.317-.843-.504a1 1 0 10-1.51 1.31c.562.649 1.413 1.076 2.353 1.253V15a1 1 0 102 0v-.092a4.535 4.535 0 001.676-.662C13.398 13.766 14 12.991 14 12c0-.99-.602-1.765-1.324-2.246A4.535 4.535 0 0011 9.092V7.151c.391.127.68.317.843.504a1 1 0 101.51-1.31c-.562-.649-1.413-1.076-2.353-1.253V5z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def department_badge("HR") do
    assigns = "HR"
    ~H"""
    <span class="badge badge-warning gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3z"/>
        <path d="M6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def department_badge("Sales") do
    assigns = "Sales"
    ~H"""
    <span class="badge badge-success gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M3 3a1 1 0 000 2v8a2 2 0 002 2h2.586l-1.293 1.293a1 1 0 101.414 1.414L10 15.414l2.293 2.293a1 1 0 001.414-1.414L12.414 15H15a2 2 0 002-2V5a1 1 0 100-2H3zm11.707 4.707a1 1 0 00-1.414-1.414L10 9.586 8.707 8.293a1 1 0 00-1.414 0l-2 2a1 1 0 101.414 1.414L8 10.414l1.293 1.293a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def department_badge(department) do
    assigns = department
    ~H"""
    <span class="badge badge-ghost"><%= assigns %></span>
    """
  end

  def level_badge("senior") do
    assigns = "Senior"
    ~H"""
    <span class="badge badge-success gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def level_badge("lead") do
    assigns = "Lead"
    ~H"""
    <span class="badge badge-info gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M9.383 3.076A1 1 0 0110 4v12a1 1 0 01-1.707.707L4.586 13H2a1 1 0 01-1-1V8a1 1 0 011-1h2.586l3.707-3.707a1 1 0 011.09-.217zM15.657 6.343a1 1 0 011.414 0 9.972 9.972 0 010 14.142 1 1 0 11-1.414-1.414 7.971 7.971 0 000-11.314 1 1 0 010-1.414z" clip-rule="evenodd"/>
        <path fill-rule="evenodd" d="M13.657 8.343a1 1 0 011.414 0 5.972 5.972 0 010 8.442 1 1 0 11-1.414-1.414 3.972 3.972 0 000-5.614 1 1 0 010-1.414z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def level_badge("mid") do
    assigns = "Mid"
    ~H"""
    <span class="badge badge-warning gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M10 2L3 7v11a1 1 0 001 1h3a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1h3a1 1 0 001-1V7l-7-5z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def level_badge("junior") do
    assigns = "Junior"
    ~H"""
    <span class="badge badge-ghost gap-1">
      <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
      </svg>
      <%= assigns %>
    </span>
    """
  end

  def level_badge(level) do
    assigns = level
    ~H"""
    <span class="badge badge-outline"><%= assigns %></span>
    """
  end
end