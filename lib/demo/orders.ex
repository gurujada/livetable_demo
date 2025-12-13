defmodule Demo.Orders do
  @moduledoc """
  Context for Demo 5: Orders - Multiple Filters Combined
  """
  alias Demo.Repo
  alias Demo.Orders.Order

  def list_orders do
    Repo.all(Order)
  end

  def get_order!(id), do: Repo.get!(Order, id)

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def count_orders do
    Repo.aggregate(Order, :count)
  end

  def statuses, do: ~w(pending confirmed shipped delivered cancelled)
  def payment_statuses, do: ~w(pending paid refunded partially_paid)
end
