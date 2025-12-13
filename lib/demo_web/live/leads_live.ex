defmodule DemoWeb.LeadsLive do
  @moduledoc """
  Demo 8: Advanced Filters - Leads
  Demonstrates: Transformers for complex business logic filtering (15,000 rows).

  This demo showcases LiveTable's Transformer feature - the most powerful filter type
  that allows full query modification including JOINs, aggregations, and complex WHERE clauses.
  """
  use DemoWeb, :live_view
  use LiveTable.LiveResource

  import Ecto.Query
  alias DemoWeb.Layouts
  alias LiveTable.{Boolean, Select, Range, Transformer}
  import DemoWeb.Helpers, only: [format_currency: 1]

  def mount(_params, _session, socket) do
    socket = assign(socket, :data_provider, {__MODULE__, :base_query, []})
    {:ok, socket}
  end

  def base_query do
    from l in Demo.Leads.Lead,
      join: src in assoc(l, :source),
      as: :source,
      join: stg in assoc(l, :stage),
      as: :stage,
      join: rep in assoc(l, :sales_rep),
      as: :sales_rep,
      select: %{
        id: l.id,
        name: l.name,
        email: l.email,
        phone: l.phone,
        company_name: l.company_name,
        deal_value: l.deal_value,
        is_hot: l.is_hot,
        last_contacted_at: l.last_contacted_at,
        source_name: src.name,
        stage_name: stg.name,
        stage_position: stg.position,
        sales_rep_name: rep.name,
        sales_rep_territory: rep.territory,
        inserted_at: l.inserted_at
      }
  end

  def fields do
    [
      id: %{label: "ID", hidden: true, sortable: false},
      name: %{label: "Name", sortable: true, searchable: true},
      company_name: %{label: "Company", sortable: true, searchable: true},
      deal_value: %{label: "Deal Value", sortable: true, renderer: &format_deal_value/1},
      stage_name: %{
        label: "Stage",
        renderer: &render_stage/1,
        sortable: false,
        assoc: {:stage, :name}
      },
      source_name: %{label: "Source", sortable: false, assoc: {:source, :name}},
      sales_rep_name: %{
        label: "Sales Rep",
        searchable: true,
        sortable: false,
        assoc: {:sales_rep, :name}
      },
      is_hot: %{label: "Hot", renderer: &render_hot/1, sortable: false},
      last_contacted_at: %{
        label: "Last Contact",
        sortable: true,
        renderer: &render_last_contact/1
      }
    ]
  end

  def filters do
    [
      # === TRANSFORMERS (Advanced Business Logic) ===

      # Easy Transformer: Days since last contact
      # Filters leads not contacted within X days (demonstrates date filtering via transformer)
      days_since_contact:
        Transformer.new("days_since_contact", %{
          label: "Not Contacted In",
          type: :select,
          field: "days",
          placeholder: "Any time",
          options: [
            %{label: "7+ days", value: "7"},
            %{label: "14+ days", value: "14"},
            %{label: "30+ days", value: "30"},
            %{label: "60+ days", value: "60"},
            %{label: "90+ days", value: "90"}
          ],
          query_transformer: &filter_by_days_since_contact/2
        }),

      # Medium Transformer: Deal Value Tiers (business logic)
      # Categorizes deals by business-defined tiers, not just numeric ranges
      deal_tier:
        Transformer.new("deal_tier", %{
          label: "Deal Tier",
          type: :select,
          field: "tier",
          placeholder: "All tiers",
          options: [
            %{label: "Small (< ₹1L)", value: "small"},
            %{label: "Medium (₹1L - ₹5L)", value: "medium"},
            %{label: "Large (₹5L - ₹20L)", value: "large"},
            %{label: "Enterprise (> ₹20L)", value: "enterprise"}
          ],
          query_transformer: &filter_by_deal_tier/2
        }),

      # === STANDARD FILTERS ===
      stage:
        Select.new({:stage, :name}, "stage", %{
          label: "Stage",
          mode: :tags,
          options: [
            %{label: "New", value: ["New"]},
            %{label: "Contacted", value: ["Contacted"]},
            %{label: "Qualified", value: ["Qualified"]},
            %{label: "Proposal", value: ["Proposal"]},
            %{label: "Negotiation", value: ["Negotiation"]},
            %{label: "Won", value: ["Won"]},
            %{label: "Lost", value: ["Lost"]}
          ]
        }),
      source:
        Select.new({:source, :name}, "source", %{
          label: "Source",
          mode: :tags,
          options: [
            %{label: "Website", value: ["Website"]},
            %{label: "Referral", value: ["Referral"]},
            %{label: "LinkedIn", value: ["LinkedIn"]},
            %{label: "Trade Show", value: ["Trade Show"]},
            %{label: "Cold Call", value: ["Cold Call"]},
            %{label: "Google Ads", value: ["Google Ads"]}
          ]
        }),
      territory:
        Select.new({:sales_rep, :territory}, "territory", %{
          label: "Territory",
          mode: :tags,
          options: [
            %{label: "North", value: ["North"]},
            %{label: "South", value: ["South"]},
            %{label: "East", value: ["East"]},
            %{label: "West", value: ["West"]},
            %{label: "Central", value: ["Central"]}
          ]
        }),
      deal_value:
        Range.new(:deal_value, "deal_value", %{
          type: :number,
          label: "Deal Value",
          unit: "₹",
          min: 10000,
          max: 5_000_000,
          step: 50000
        }),
      hot_leads:
        Boolean.new(:is_hot, "hot", %{
          label: "Hot Leads Only",
          condition: dynamic([l], l.is_hot == true)
        }),
      active_pipeline:
        Boolean.new(:stage_id, "active_pipeline", %{
          label: "Active Pipeline",
          condition: dynamic([l, stage: s], s.name not in ["Won", "Lost"])
        })
    ]
  end

  # === TRANSFORMER FUNCTIONS ===

  # Easy: Filter by days since last contact
  defp filter_by_days_since_contact(query, %{"days" => ""}) do
    query
  end

  defp filter_by_days_since_contact(query, %{"days" => days_str}) do
    days = String.to_integer(days_str)
    cutoff_date = DateTime.add(DateTime.utc_now(), -days, :day)

    from l in query,
      where: is_nil(l.last_contacted_at) or l.last_contacted_at < ^cutoff_date
  end

  defp filter_by_days_since_contact(query, _), do: query

  # Medium: Filter by deal tier (business logic tiers)
  defp filter_by_deal_tier(query, %{"tier" => ""}) do
    query
  end

  defp filter_by_deal_tier(query, %{"tier" => "small"}) do
    from l in query, where: l.deal_value < 100_000
  end

  defp filter_by_deal_tier(query, %{"tier" => "medium"}) do
    from l in query, where: l.deal_value >= 100_000 and l.deal_value < 500_000
  end

  defp filter_by_deal_tier(query, %{"tier" => "large"}) do
    from l in query, where: l.deal_value >= 500_000 and l.deal_value < 2_000_000
  end

  defp filter_by_deal_tier(query, %{"tier" => "enterprise"}) do
    from l in query, where: l.deal_value >= 2_000_000
  end

  defp filter_by_deal_tier(query, _), do: query

  # === ACTIONS ===

  def actions do
    %{
      label: "Actions",
      items: [
        view: &view_action/1,
        contact: &contact_action/1
      ]
    }
  end

  defp view_action(assigns) do
    ~H"""
    <button
      phx-click="view_lead"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-eye" class="size-4" /> View Details
    </button>
    """
  end

  defp contact_action(assigns) do
    ~H"""
    <button
      phx-click="contact_lead"
      phx-value-id={@record.id}
      class="flex items-center gap-2 w-full px-3 py-2 text-sm rounded-md hover:bg-accent transition-colors"
    >
      <.icon name="lucide-phone" class="size-4" /> Log Contact
    </button>
    """
  end

  def table_options do
    %{
      pagination: %{enabled: true, sizes: [10, 25, 50, 100], default_size: 25},
      sorting: %{enabled: true, default_sort: [deal_value: :desc]},
      search: %{enabled: true, debounce: 300, placeholder: "Search leads..."}
    }
  end

  def handle_event("view_lead", %{"id" => _id}, socket) do
    {:noreply,
     put_flash(socket, :info, "In a real app, this would navigate to the lead detail page")}
  end

  def handle_event("contact_lead", %{"id" => _id}, socket) do
    {:noreply, put_flash(socket, :info, "In a real app, this would open the contact log form")}
  end

  # === RENDERERS ===

  defp format_deal_value(value) do
    formatted = format_currency(value)
    assigns = %{formatted: formatted}

    ~H"""
    <span class="font-mono text-green-700 dark:text-green-400">₹{@formatted}</span>
    """
  end

  defp render_stage(stage_name) do
    color =
      case stage_name do
        "New" ->
          "bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-400"

        "Contacted" ->
          "bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400"

        "Qualified" ->
          "bg-indigo-100 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400"

        "Proposal" ->
          "bg-purple-100 dark:bg-purple-900/30 text-purple-700 dark:text-purple-400"

        "Negotiation" ->
          "bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400"

        "Won" ->
          "bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400"

        "Lost" ->
          "bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400"

        _ ->
          "bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-400"
      end

    assigns = %{stage_name: stage_name, color: color}

    ~H"""
    <span class={["px-2 py-1 text-xs rounded-full", @color]}>{@stage_name}</span>
    """
  end

  defp render_hot(is_hot) do
    assigns = %{is_hot: is_hot}

    ~H"""
    <span
      :if={@is_hot}
      class="px-2 py-1 text-xs rounded-full bg-orange-100 dark:bg-orange-900/30 text-orange-700 dark:text-orange-400 font-medium"
    >
      Hot
    </span>
    <span :if={!@is_hot} class="text-muted-foreground">-</span>
    """
  end

  defp render_last_contact(nil) do
    assigns = %{}

    ~H"""
    <span class="text-red-500 dark:text-red-400 text-sm">Never contacted</span>
    """
  end

  defp render_last_contact(datetime) do
    days_ago = DateTime.diff(DateTime.utc_now(), datetime, :day)
    is_stale = days_ago > 30
    assigns = %{datetime: datetime, days_ago: days_ago, is_stale: is_stale}

    ~H"""
    <div class={if @is_stale, do: "text-red-600 dark:text-red-400", else: ""}>
      <div class="text-sm">{Calendar.strftime(@datetime, "%d %b %Y")}</div>
      <div class="text-xs text-muted-foreground">{@days_ago} days ago</div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Layouts.page_header
          number={8}
          title="Leads"
          rows="15K rows"
          description="Transformers demo - custom query filters for 'Days Since Contact' and 'Deal Tier' business logic."
        />

        <.live_table
          fields={fields()}
          filters={filters()}
          actions={actions()}
          options={@options}
          streams={@streams}
        />
      </div>
    </Layouts.app>
    """
  end
end
