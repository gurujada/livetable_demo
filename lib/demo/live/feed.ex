defmodule Demo.Live.Feed do
  @moduledoc """
  Simulates a shop's order feed while someone is watching.

  The first viewer starts it; it stops 30 seconds after the last one leaves, so an idle demo
  costs nothing. The feed keeps the newest 120 orders and deletes older ones.
  """
  use GenServer, restart: :temporary

  import Ecto.Query
  alias Demo.Live.Order
  alias Demo.{Repo, SeedData}

  @topic "live_orders"
  @stats_topic "live_orders:stats"
  @keep 120
  @tick 1_800
  @idle_stop 30_000
  @recent 32

  def topic, do: @topic

  @doc "Subscribes the calling LiveView to the stats and keeps the feed running while it lives."
  def watch(pid \\ self()) do
    Phoenix.PubSub.subscribe(Demo.PubSub, @stats_topic)

    case DynamicSupervisor.start_child(Demo.Live.Supervisor, __MODULE__) do
      {:ok, _} -> :ok
      {:error, {:already_started, _}} -> :ok
    end

    GenServer.call(__MODULE__, {:watch, pid})
  end

  @doc "Makes one change now, as a visitor's \"Make a change\" click."
  def poke, do: GenServer.cast(__MODULE__, :poke)

  @doc "Moves the orders in `query` to `status`, for bulk actions."
  def set_status(query, status), do: GenServer.call(__MODULE__, {:set_status, query, status})

  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @impl true
  def init(nil) do
    # A quiet hour of history, so the feed starts with orders at every stage.
    if Repo.aggregate(Order, :count) == 0 do
      for minutes <- 60..1//-1 do
        status = Enum.random(~w(delivered delivered shipped shipped packed new))
        insert_order(status, DateTime.add(DateTime.utc_now(), -minutes, :minute))
      end
    end

    recent = Repo.all(from o in Order, order_by: [desc: o.id], limit: @recent, select: o.amount)
    Process.send_after(self(), :tick, @tick)

    {:ok,
     %{viewers: %{}, stop: Process.send_after(self(), :idle_stop, @idle_stop), recent: recent}}
  end

  @impl true
  def handle_call({:watch, pid}, _from, state) do
    if state.stop, do: Process.cancel_timer(state.stop)
    viewers = Map.put(state.viewers, Process.monitor(pid), pid)
    {:reply, stats(state), %{state | viewers: viewers, stop: nil}}
  end

  def handle_call({:set_status, query, status}, _from, state) do
    ids = Repo.all(select(query, [o], o.id))
    now = DateTime.utc_now()
    Repo.update_all(where(Order, [o], o.id in ^ids), set: [status: status, updated_at: now])
    {:reply, length(ids), changed(ids, state)}
  end

  @impl true
  def handle_cast(:poke, state), do: {:noreply, event(state)}

  @impl true
  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, @tick)
    {:noreply, if(state.viewers == %{}, do: state, else: event(state))}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    viewers = Map.delete(state.viewers, ref)

    stop =
      if viewers == %{}, do: Process.send_after(self(), :idle_stop, @idle_stop), else: state.stop

    {:noreply, %{state | viewers: viewers, stop: stop}}
  end

  def handle_info(:idle_stop, %{viewers: viewers} = state) when viewers == %{},
    do: {:stop, :normal, state}

  def handle_info(:idle_stop, state), do: {:noreply, state}

  # Mostly new orders; otherwise an order moves one step along.
  defp event(state) do
    if :rand.uniform() < 0.45 do
      order = insert_order("new", DateTime.utc_now())

      old =
        Repo.all(from o in Order, order_by: [desc: o.inserted_at], offset: @keep, select: o.id)

      Repo.delete_all(where(Order, [o], o.id in ^old))

      changed([order.id | old], %{
        state
        | recent: Enum.take([order.amount | state.recent], @recent)
      })
    else
      case Repo.one(
             from o in Order,
               where: o.status != "delivered",
               order_by: fragment("random()"),
               limit: 1
           ) do
        nil ->
          state

        order ->
          next =
            Enum.at(
              Order.statuses(),
              Enum.find_index(Order.statuses(), &(&1 == order.status)) + 1
            )

          order |> Ecto.Changeset.change(status: next) |> Repo.update!()
          changed([order.id], state)
      end
    end
  end

  defp changed(ids, state) do
    LiveTable.broadcast(Demo.PubSub, @topic, ids)
    Phoenix.PubSub.broadcast(Demo.PubSub, @stats_topic, {:stats, stats(state)})
    state
  end

  defp stats(state) do
    counts = Map.new(Repo.all(from o in Order, group_by: o.status, select: {o.status, count()}))

    %{
      orders: counts |> Map.values() |> Enum.sum(),
      revenue: Repo.aggregate(Order, :sum, :amount) || Decimal.new(0),
      waiting: Map.get(counts, "new", 0) + Map.get(counts, "packed", 0),
      shipped: Map.get(counts, "shipped", 0) + Map.get(counts, "delivered", 0),
      recent: Enum.reverse(state.recent)
    }
  end

  defp insert_order(status, at) do
    {city, _state} = SeedData.random_city_state()

    Repo.insert!(%Order{
      inserted_at: at,
      updated_at: at,
      number: "#{:rand.uniform(89_999) + 10_000}",
      customer: SeedData.random_full_name(),
      city: city,
      amount: Decimal.new(Enum.random(299..24_999)),
      status: status
    })
  end
end
