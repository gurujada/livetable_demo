defmodule DemoWeb.ProjectsLive do
  @moduledoc """
  Demo 9: Card Mode - Projects
  Demonstrates: card layout with infinite scroll (5,000 rows).
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource

  import Ecto.Query
  alias DemoWeb.Layouts
  alias LiveTable.{Boolean, Select, Range}
  import DemoWeb.Helpers, only: [format_currency: 1]

  def mount(_params, _session, socket) do
    socket = assign(socket, :data_provider, {__MODULE__, :base_query, []})
    {:ok, socket}
  end

  def base_query do
    from p in Demo.Projects.Project,
      join: c in assoc(p, :client),
      as: :client,
      join: pt in assoc(p, :project_type),
      as: :project_type,
      select: %{
        id: p.id,
        name: p.name,
        description: p.description,
        status: p.status,
        budget: p.budget,
        spent: p.spent,
        start_date: p.start_date,
        end_date: p.end_date,
        progress: p.progress,
        team_size: p.team_size,
        is_featured: p.is_featured,
        client_name: c.name,
        client_industry: c.industry,
        client_city: c.city,
        project_type: pt.name
      }
  end

  def fields do
    [
      id: %{label: "ID", hidden: true, sortable: false},
      name: %{label: "Project", sortable: true, searchable: true},
      client_name: %{label: "Client", sortable: true, searchable: true, assoc: {:client, :name}},
      project_type: %{label: "Type", sortable: false, assoc: {:project_type, :name}},
      status: %{label: "Status", sortable: false},
      budget: %{label: "Budget", sortable: true},
      progress: %{label: "Progress", sortable: false},
      team_size: %{label: "Team", sortable: false}
    ]
  end

  # TODO: Add Select filter for status once lookup table is created
  # See database_tasks.md for details
  def filters do
    [
      project_type:
        Select.new({:project_type, :name}, "project_type", %{
          label: "Project Type",
          mode: :tags,
          options: [
            %{label: "Web Development", value: ["Web Development"]},
            %{label: "Mobile App", value: ["Mobile App"]},
            %{label: "E-commerce", value: ["E-commerce"]},
            %{label: "ERP Implementation", value: ["ERP Implementation"]},
            %{label: "Cloud Migration", value: ["Cloud Migration"]},
            %{label: "Data Analytics", value: ["Data Analytics"]},
            %{label: "Security Audit", value: ["Security Audit"]},
            %{label: "IT Consulting", value: ["IT Consulting"]}
          ]
        }),
      industry:
        Select.new({:client, :industry}, "industry", %{
          label: "Industry",
          mode: :tags,
          options: [
            %{label: "Technology", value: ["Technology"]},
            %{label: "Finance", value: ["Finance"]},
            %{label: "Healthcare", value: ["Healthcare"]},
            %{label: "Retail", value: ["Retail"]},
            %{label: "Manufacturing", value: ["Manufacturing"]},
            %{label: "Education", value: ["Education"]}
          ]
        }),
      budget_range:
        Range.new(:budget, "budget_range", %{
          label: "Budget",
          unit: "₹",
          min: 100_000,
          max: 10_000_000,
          step: 100_000,
          default_min: 100_000,
          default_max: 10_000_000
        }),
      featured:
        Boolean.new(:is_featured, "featured", %{
          label: "Featured Only",
          condition: dynamic([p], p.is_featured == true)
        }),
      active_projects:
        Boolean.new(:status, "active", %{
          label: "Active Projects",
          condition: dynamic([p], p.status == "active")
        }),
      at_risk:
        Boolean.new(:progress, "at_risk", %{
          label: "At Risk (Progress < 50% past midpoint)",
          condition:
            dynamic(
              [p],
              p.progress < 50 and
                fragment("? < CURRENT_DATE - (? - ?) / 2", p.start_date, p.end_date, p.start_date)
            )
        })
    ]
  end

  def table_options do
    %{
      mode: :card,
      card_component: &project_card/1,
      pagination: %{
        enabled: true,
        sizes: [12, 24, 48],
        default_size: 12
      },
      sorting: %{
        enabled: true,
        default_sort: [start_date: :desc]
      },
      search: %{
        enabled: true,
        debounce: 300,
        placeholder: "Search projects..."
      }
    }
  end

  defp project_card(assigns) do
    ~H"""
    <div class="bg-card rounded-lg border border-border shadow-sm hover:shadow-md transition-shadow overflow-hidden">
      <div class="p-5">
        <div class="flex items-start justify-between mb-3">
          <div class="flex-1 min-w-0">
            <h3 class="text-lg font-semibold text-card-foreground truncate">
              {@record.name}
            </h3>
            <p class="text-sm text-muted-foreground">{@record.client_name}</p>
          </div>
          <.status_badge status={@record.status} />
        </div>

        <div class="flex flex-wrap gap-2 mb-4">
          <span class="px-2 py-1 text-xs rounded-full bg-primary/10 text-primary">
            {@record.project_type}
          </span>
          <span class="px-2 py-1 text-xs rounded-full bg-secondary text-secondary-foreground">
            {@record.client_industry}
          </span>
          <span
            :if={@record.is_featured}
            class="px-2 py-1 text-xs rounded-full bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400"
          >
            Featured
          </span>
        </div>

        <div class="mb-4">
          <div class="flex justify-between text-sm mb-1">
            <span class="text-muted-foreground">Progress</span>
            <span class="font-medium">{@record.progress}%</span>
          </div>
          <div class="w-full bg-muted rounded-full h-2">
            <div
              class={[
                "h-2 rounded-full transition-all",
                progress_color(@record.progress)
              ]}
              style={"width: #{@record.progress}%"}
            >
            </div>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4 mb-4">
          <div>
            <p class="text-xs text-muted-foreground">Budget</p>
            <p class="font-mono font-medium text-green-600 dark:text-green-400">
              ₹{format_currency(@record.budget)}
            </p>
          </div>
          <div>
            <p class="text-xs text-muted-foreground">Spent</p>
            <p class={[
              "font-mono font-medium",
              if(@record.spent && Decimal.compare(@record.spent, @record.budget) == :gt,
                do: "text-red-600 dark:text-red-400",
                else: "text-muted-foreground"
              )
            ]}>
              ₹{format_currency(@record.spent)}
            </p>
          </div>
        </div>

        <div class="flex items-center justify-between text-sm text-muted-foreground pt-3 border-t border-border">
          <div class="flex items-center gap-1">
            <span>Team:</span>
            <span class="font-medium text-foreground">{@record.team_size}</span>
          </div>
          <div>
            {format_date_range(@record.start_date, @record.end_date)}
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp status_badge(assigns) do
    {bg, text} =
      case assigns.status do
        "planning" ->
          {"bg-gray-100 dark:bg-gray-800", "text-gray-700 dark:text-gray-400"}

        "active" ->
          {"bg-blue-100 dark:bg-blue-900/30", "text-blue-700 dark:text-blue-400"}

        "on_hold" ->
          {"bg-yellow-100 dark:bg-yellow-900/30", "text-yellow-700 dark:text-yellow-400"}

        "completed" ->
          {"bg-green-100 dark:bg-green-900/30", "text-green-700 dark:text-green-400"}

        "cancelled" ->
          {"bg-red-100 dark:bg-red-900/30", "text-red-700 dark:text-red-400"}

        _ ->
          {"bg-gray-100 dark:bg-gray-800", "text-gray-700 dark:text-gray-400"}
      end

    assigns = assign(assigns, :bg, bg)
    assigns = assign(assigns, :text, text)

    ~H"""
    <span class={["px-2.5 py-1 text-xs rounded-full font-medium capitalize", @bg, @text]}>
      {String.replace(@status, "_", " ")}
    </span>
    """
  end

  defp progress_color(progress) when progress >= 75, do: "bg-green-500"
  defp progress_color(progress) when progress >= 50, do: "bg-blue-500"
  defp progress_color(progress) when progress >= 25, do: "bg-yellow-500"
  defp progress_color(_), do: "bg-red-500"

  defp format_date_range(start_date, nil) do
    "#{Calendar.strftime(start_date, "%b %Y")} - Ongoing"
  end

  defp format_date_range(start_date, end_date) do
    "#{Calendar.strftime(start_date, "%b %Y")} - #{Calendar.strftime(end_date, "%b %Y")}"
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={9}
          title="Projects"
          rows="5K rows"
          description="Card mode with infinite scroll. Data displayed as cards instead of table rows."
        />

        <.live_table
          fields={fields()}
          filters={filters()}
          options={@options}
          streams={@streams}
        />
      </div>
    </Layouts.app>
    """
  end
end
