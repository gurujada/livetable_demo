defmodule DemoWeb.ProjectsLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource

  alias LiveTable.{Boolean, Range, Select}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :data_provider, {__MODULE__, :projects, []})}
  end

  def projects do
    from p in Demo.Projects.Project,
      join: c in assoc(p, :client),
      as: :client,
      join: t in assoc(p, :project_type),
      as: :project_type,
      select: %{
        id: p.id,
        name: p.name,
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
        project_type: t.name
      }
  end

  def fields do
    [
      name: %{label: "Project", sortable: true, searchable: true},
      client_name: %{label: "Client", sortable: true, searchable: true, assoc: {:client, :name}},
      budget: %{label: "Budget", sortable: true},
      progress: %{label: "Progress", sortable: true}
    ]
  end

  def filters do
    [
      type:
        Select.new({:project_type, :name}, "type", %{
          label: "Type",
          mode: :tags,
          options_source: {Demo.Projects, :search_project_types, []}
        }),
      budget:
        Range.new(:budget, "budget", %{
          label: "Budget, ₹1L to ₹1Cr",
          min: 100_000,
          max: 10_000_000,
          step: 100_000,
          pips: true,
          pips_mode: "count",
          pips_values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
          css_classes: "pips-without-labels"
        }),
      featured:
        Boolean.new(:is_featured, "featured", %{
          label: "Featured",
          condition: dynamic([p], p.is_featured)
        })
    ]
  end

  # Select cards, then act on all of them in one query.
  def bulk_actions do
    [
      feature: %{label: "Feature", handler: &set_featured(&1, &2, true)},
      unfeature: %{label: "Unfeature", handler: &set_featured(&1, &2, false)}
    ]
  end

  defp set_featured(query, socket, featured) do
    {count, _} = Demo.Repo.update_all(query, set: [is_featured: featured])

    put_flash(
      socket,
      :info,
      "#{if featured, do: "Featured", else: "Unfeatured"} #{count} projects."
    )
  end

  def table_options do
    %{
      mode: :card,
      card_component: &project_card/1,
      pagination: %{mode: :infinite_scroll, default_size: 12},
      sorting: %{default_sort: [name: :asc]},
      search: %{placeholder: "Search project or client"},
      exports: %{enabled: false}
    }
  end

  # The card draws its own checkbox for bulk actions; the ring shows it's selected.
  defp project_card(assigns) do
    ~H"""
    <label class="block h-full cursor-pointer bg-card rounded-lg border border-border shadow-sm hover:shadow-md transition-shadow overflow-hidden has-[:checked]:border-cyan-500 has-[:checked]:ring-2 has-[:checked]:ring-cyan-500/30">
      <div class="p-5">
        <div class="flex items-start justify-between gap-3 mb-3">
          <input
            type="checkbox"
            class="mt-1.5 size-4 accent-cyan-500"
            data-live-table-select
            value={@row_id}
          />
          <div class="flex-1 min-w-0">
            <h3 class="text-lg font-semibold text-card-foreground truncate">{@record.name}</h3>
            <p class="text-sm text-muted-foreground">{@record.client_name}</p>
          </div>
          <.pill value={@record.status} />
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
              class={["h-2 rounded-full", progress_color(@record.progress)]}
              style={"width: #{@record.progress}%"}
            >
            </div>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4 mb-4">
          <div>
            <p class="text-xs text-muted-foreground">Budget</p>
            <p>{money(@record.budget)}</p>
          </div>
          <div>
            <p class="text-xs text-muted-foreground">Spent</p>
            <p
              :if={over_budget?(@record)}
              class="font-mono font-medium text-red-600 dark:text-red-400"
            >
              ₹{format_currency(@record.spent)}
            </p>
            <p :if={!over_budget?(@record)}>{cost(@record.spent)}</p>
          </div>
        </div>

        <div class="flex items-center justify-between text-sm text-muted-foreground pt-3 border-t border-border">
          <span>Team <span class="font-medium text-foreground">{@record.team_size}</span></span>
          <span>{dates(@record.start_date, @record.end_date)}</span>
        </div>
      </div>
    </label>
    """
  end

  defp over_budget?(%{spent: spent, budget: budget}),
    do: spent != nil and Decimal.compare(spent, budget) == :gt

  defp progress_color(progress) when progress >= 75, do: "bg-green-500"
  defp progress_color(progress) when progress >= 50, do: "bg-blue-500"
  defp progress_color(progress) when progress >= 25, do: "bg-yellow-500"
  defp progress_color(_), do: "bg-red-500"

  defp dates(start, nil), do: "#{Calendar.strftime(start, "%b %Y")} - Ongoing"

  defp dates(start, finish),
    do: "#{Calendar.strftime(start, "%b %Y")} - #{Calendar.strftime(finish, "%b %Y")}"

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <Layouts.demo
        path="/projects"
        title="Projects"
        rows="5K rows"
        source={__source__()}
        try="Pick a few cards, then Feature them. Scroll to load more."
      >
        <:intro>
          The same table as cards, loading more as you scroll. Each card draws its own checkbox
          for bulk actions.
        </:intro>
        <.live_table
          fields={fields()}
          filters={filters()}
          options={@options}
          streams={@streams}
          bulk_actions={bulk_actions()}
        />
      </Layouts.demo>
    </Layouts.app>
    """
  end
end
