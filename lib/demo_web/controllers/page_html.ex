defmodule DemoWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use DemoWeb, :html

  embed_templates "page_html/*"

  @doc """
  Returns the code example for the home page.
  """
  def code_example do
    """
    defmodule MyAppWeb.UsersLive do
      use MyAppWeb, :live_view
      use LiveTable.LiveResource, schema: MyApp.Accounts.User

      def fields do
        [
          name:  %{label: "Name", sortable: true, searchable: true},
          email: %{label: "Email", sortable: true},
          role:  %{label: "Role", sortable: true}
        ]
      end

      def filters do
        [
          role: Select.new(:role, "role", %{label: "Role", options: [...]}),
          active: Boolean.new(:active, "active", %{label: "Active Only"})
        ]
      end
    end
    """
  end

  @doc """
  Returns syntax-highlighted HTML for the code example.
  """
  def highlighted_code_example do
    {:safe,
     """
     <span class="text-purple-400">defmodule</span> <span class="text-cyan-300">MyAppWeb.UsersLive</span> <span class="text-purple-400">do</span>
       <span class="text-purple-400">use</span> <span class="text-cyan-300">MyAppWeb</span>, <span class="text-amber-300">:live_view</span>
       <span class="text-purple-400">use</span> <span class="text-cyan-300">LiveTable.LiveResource</span>, <span class="text-amber-300">schema:</span> <span class="text-cyan-300">MyApp.Accounts.User</span>

       <span class="text-purple-400">def</span> <span class="text-cyan-400">fields</span> <span class="text-purple-400">do</span>
         [
           <span class="text-amber-300">name:</span>  <span class="text-gray-500">%{</span><span class="text-amber-300">label:</span> <span class="text-green-400">"Name"</span>, <span class="text-amber-300">sortable:</span> <span class="text-purple-400">true</span>, <span class="text-amber-300">searchable:</span> <span class="text-purple-400">true</span><span class="text-gray-500">}</span>,
           <span class="text-amber-300">email:</span> <span class="text-gray-500">%{</span><span class="text-amber-300">label:</span> <span class="text-green-400">"Email"</span>, <span class="text-amber-300">sortable:</span> <span class="text-purple-400">true</span><span class="text-gray-500">}</span>,
           <span class="text-amber-300">role:</span>  <span class="text-gray-500">%{</span><span class="text-amber-300">label:</span> <span class="text-green-400">"Role"</span>, <span class="text-amber-300">sortable:</span> <span class="text-purple-400">true</span><span class="text-gray-500">}</span>
         ]
       <span class="text-purple-400">end</span>

       <span class="text-purple-400">def</span> <span class="text-cyan-400">filters</span> <span class="text-purple-400">do</span>
         [
           <span class="text-amber-300">role:</span> <span class="text-cyan-300">Select</span>.new(<span class="text-amber-300">:role</span>, <span class="text-green-400">"role"</span>, <span class="text-gray-500">%{</span><span class="text-amber-300">label:</span> <span class="text-green-400">"Role"</span>, ...<span class="text-gray-500">}</span>),
           <span class="text-amber-300">active:</span> <span class="text-cyan-300">Boolean</span>.new(<span class="text-amber-300">:active</span>, <span class="text-green-400">"active"</span>, <span class="text-gray-500">%{</span><span class="text-amber-300">label:</span> <span class="text-green-400">"Active Only"</span><span class="text-gray-500">}</span>)
         ]
       <span class="text-purple-400">end</span>
     <span class="text-purple-400">end</span>
     """}
  end

  @doc """
  Renders a demo card for the home page.
  """
  attr :number, :integer, required: true
  attr :name, :string, required: true
  attr :href, :string, required: true
  attr :description, :string, required: true
  attr :features, :list, default: []
  attr :featured, :boolean, default: false

  def demo_card(assigns) do
    ~H"""
    <a
      href={@href}
      class={[
        "group relative flex flex-col p-5 rounded-xl border transition-all duration-300 overflow-hidden h-full",
        @featured &&
          "border-cyan-500/50 bg-gradient-to-br from-cyan-500/10 via-card to-purple-500/5 hover:border-cyan-400/70 hover:shadow-lg hover:shadow-cyan-500/20",
        !@featured && "border-border/60 bg-card/50 hover:border-cyan-500/40 hover:bg-card/80"
      ]}
    >
      <!-- Number + Name row -->
      <div class="flex items-center gap-3 mb-3">
        <span class={[
          "flex items-center justify-center w-8 h-8 rounded-lg text-sm font-bold transition-all duration-300 font-mono",
          @featured && "bg-gradient-to-br from-cyan-500 to-purple-600 text-white shadow-md",
          !@featured &&
            "bg-muted text-muted-foreground group-hover:bg-cyan-500/20 group-hover:text-cyan-400"
        ]}>
          {@number}
        </span>
        <h3 class={[
          "font-display font-semibold text-foreground transition-colors",
          "group-hover:text-cyan-400"
        ]}>
          {@name}
        </h3>
        <span
          :if={@featured}
          class="ml-auto px-2 py-0.5 text-xs font-mono font-bold rounded bg-cyan-500/20 text-cyan-400"
        >
          1M rows
        </span>
      </div>
      
    <!-- Description -->
      <p class="text-sm text-muted-foreground leading-relaxed mb-3 flex-1">{@description}</p>
      
    <!-- Feature tags -->
      <div :if={@features != []} class="flex flex-wrap gap-1.5">
        <span
          :for={feature <- @features}
          class="px-2 py-0.5 text-xs rounded bg-muted/50 text-muted-foreground/80 font-medium"
        >
          {feature}
        </span>
      </div>
      
    <!-- Arrow on hover -->
      <div class="absolute bottom-4 right-4 opacity-0 group-hover:opacity-100 transition-all duration-300 translate-x-1 group-hover:translate-x-0">
        <.icon name="lucide-arrow-right" class="size-4 text-cyan-400" />
      </div>
    </a>
    """
  end

  @doc """
  Renders a feature item for the features section.
  """
  attr :icon, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true

  def feature_item(assigns) do
    ~H"""
    <div class="group text-center p-6 rounded-2xl transition-all duration-300 hover:bg-card/50">
      <div class="feature-icon inline-flex items-center justify-center w-14 h-14 rounded-2xl mb-4 transition-all duration-300 group-hover:scale-110">
        <.icon name={@icon} class="size-7 text-cyan-400" />
      </div>
      <h3 class="font-display font-bold text-foreground mb-2 group-hover:text-cyan-400 transition-colors">
        {@title}
      </h3>
      <p class="text-sm text-muted-foreground">{@description}</p>
    </div>
    """
  end
end
