defmodule Demo.Inventory.Warehouse do
  @moduledoc """
  Warehouse schema for Demo 7: Inventory with computed fields
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_warehouses" do
    field :name, :string
    field :city, :string
    field :state, :string
    field :region, :string

    has_many :stock_items, Demo.Inventory.StockItem

    timestamps(type: :utc_datetime)
  end

  def changeset(warehouse, attrs) do
    warehouse
    |> cast(attrs, [:name, :city, :state, :region])
    |> validate_required([:name, :city, :state, :region])
    |> validate_inclusion(:region, ~w(North South East West Central))
    |> unique_constraint(:name)
  end
end
