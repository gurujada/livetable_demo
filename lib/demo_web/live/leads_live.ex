defmodule DemoWeb.LeadsLive do
  use DemoWeb, :live_view
  use LiveTable.LiveResource

  alias LiveTable.{Boolean, Select, Transformer}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :data_provider, {__MODULE__, :leads, []})}
  end

  def leads do
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
        company_name: l.company_name,
        deal_value: l.deal_value,
        is_hot: l.is_hot,
        last_contacted_at: l.last_contacted_at,
        source: src.name,
        stage: stg.name,
        stage_position: stg.position,
        rep: rep.name
      }
  end

  def fields do
    [
      id: %{label: "ID", hidden: true},
      name: %{label: "Lead", sortable: true, searchable: true, renderer: &lead/2},
      deal_value: %{label: "Deal", sortable: true, renderer: &money/1},
      stage: %{label: "Stage", assoc: {:stage, :name}, renderer: &stage/2},
      source: %{label: "Source", assoc: {:source, :name}, renderer: &source/1},
      rep: %{label: "Owner", searchable: true, assoc: {:sales_rep, :name}, renderer: &owner/1},
      last_contacted_at: %{label: "Last contact", sortable: true, renderer: &ago/1},
      company_name: %{label: "Company", searchable: true, hidden: true},
      is_hot: %{label: "Hot", hidden: true},
      stage_position: %{label: "Stage position", hidden: true}
    ]
  end

  # A Transformer is a filter that gets the query and returns a new one: any logic you like.
  def filters do
    [
      quiet:
        Transformer.new("quiet", %{
          render: &quiet_filter/1,
          query_transformer: &not_contacted_in/2
        }),
      tier:
        Transformer.new("tier", %{
          render: &tier_filter/1,
          query_transformer: &deal_tier/2
        }),
      stage:
        Select.new({:stage, :name}, "stage", %{
          label: "Stage",
          mode: :tags,
          options_source: {Demo.Leads, :search_stages, []}
        }),
      hot: Boolean.new(:is_hot, "hot", %{label: "Hot leads", condition: dynamic([l], l.is_hot)})
    ]
  end

  defp not_contacted_in(query, %{"days" => days}) when days != "" do
    cutoff = DateTime.add(DateTime.utc_now(), -String.to_integer(days), :day)
    from l in query, where: is_nil(l.last_contacted_at) or l.last_contacted_at < ^cutoff
  end

  defp not_contacted_in(query, _), do: query

  @tiers %{
    "small" => {0, 100_000},
    "medium" => {100_000, 500_000},
    "large" => {500_000, 2_000_000},
    "enterprise" => {2_000_000, nil}
  }

  defp deal_tier(query, %{"tier" => tier}) when is_map_key(@tiers, tier) do
    case @tiers[tier] do
      {low, nil} -> from l in query, where: l.deal_value >= ^low
      {low, high} -> from l in query, where: l.deal_value >= ^low and l.deal_value < ^high
    end
  end

  defp deal_tier(query, _), do: query

  defp quiet_filter(assigns) do
    ~H"""
    <label class="block text-sm font-medium">
      Not contacted in
      <select name={"filters[#{@key}][days]"} class="select mt-2 w-full">
        <option value="">Any time</option>
        <option :for={d <- ~w(7 30 90)} value={d} selected={@value["days"] == d}>{d}+ days</option>
      </select>
    </label>
    """
  end

  defp tier_filter(assigns) do
    ~H"""
    <label class="block text-sm font-medium">
      Deal size
      <select name={"filters[#{@key}][tier]"} class="select mt-2 w-full">
        <option value="">Any size</option>
        <option value="small" selected={@value["tier"] == "small"}>Under ₹1L</option>
        <option value="medium" selected={@value["tier"] == "medium"}>₹1L to ₹5L</option>
        <option value="large" selected={@value["tier"] == "large"}>₹5L to ₹20L</option>
        <option value="enterprise" selected={@value["tier"] == "enterprise"}>Over ₹20L</option>
      </select>
    </label>
    """
  end

  defp lead(name, lead) do
    assigns = %{name: name, company: lead.company_name, hot: lead.is_hot}

    ~H"""
    <div class="flex items-center gap-2">
      <.person name={@name} sub={@company} />
      <.icon :if={@hot} name="lucide-flame" class="size-4 shrink-0 text-orange-500" />
    </div>
    """
  end

  # Where the lead is in the pipeline: one dot per stage up to Won, red when lost.
  defp stage(stage, lead) do
    assigns = %{stage: stage, position: lead.stage_position}

    ~H"""
    <div class="space-y-1">
      <div class="flex gap-1">
        <span
          :for={step <- 1..6}
          class={[
            "h-1.5 w-3 rounded-full",
            @position == 7 && "bg-red-500/70",
            @position < 7 && step <= @position &&
              if(@position == 6, do: "bg-green-500", else: "bg-cyan-500"),
            @position < 7 && step > @position && "bg-muted"
          ]}
        ></span>
      </div>
      <div class="text-xs text-muted-foreground">{@stage}</div>
    </div>
    """
  end

  @sources %{
    "Website" => "lucide-globe",
    "Referral" => "lucide-users",
    "LinkedIn" => "lucide-briefcase",
    "Facebook" => "lucide-thumbs-up",
    "Instagram" => "lucide-camera",
    "Partner" => "lucide-handshake",
    "Email Campaign" => "lucide-mail",
    "Google Ads" => "lucide-search",
    "Cold Call" => "lucide-phone",
    "Trade Show" => "lucide-presentation"
  }

  defp source(source) do
    assigns = %{source: source, icon: Map.get(@sources, source, "lucide-megaphone")}

    ~H"""
    <span class="inline-flex items-center gap-2 rounded-md bg-muted/60 px-2 py-1 text-xs">
      <.icon name={@icon} class="size-3.5 text-cyan-500" />{@source}
    </span>
    """
  end

  defp owner(name) do
    assigns = %{name: name}

    ~H"""
    <.person name={@name} />
    """
  end

  def table_options do
    %{
      pagination: %{sizes: [10, 25, 50], default_size: 25},
      sorting: %{default_sort: [deal_value: :desc]},
      search: %{placeholder: "Search lead, company or owner"},
      exports: %{enabled: false},
      max_filters: 4,
      fixed_header: true
    }
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <Layouts.demo
        path="/leads"
        title="Leads"
        rows="15K rows"
        source={__source__()}
        try="Pick leads not contacted in 90 days, then Over ₹20L."
      >
        <:intro>
          Two filters here are plain functions that rewrite the query, for rules a checkbox or
          range can't express.
        </:intro>
        <.live_table fields={fields()} filters={filters()} options={@options} streams={@streams} />
      </Layouts.demo>
    </Layouts.app>
    """
  end
end
