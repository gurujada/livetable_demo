defmodule Demo.Live.Order do
  @moduledoc "An order in the live feed."
  use Ecto.Schema

  schema "live_orders" do
    field :number, :string
    field :customer, :string
    field :city, :string
    field :amount, :decimal
    field :status, :string

    timestamps(type: :utc_datetime_usec)
  end

  def statuses, do: ~w(new packed shipped delivered)
end
