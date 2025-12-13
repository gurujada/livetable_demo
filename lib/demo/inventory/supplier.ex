defmodule Demo.Inventory.Supplier do
  @moduledoc """
  Supplier schema for Demo 7: Inventory with computed fields
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_suppliers" do
    field :name, :string
    field :contact_name, :string
    field :email, :string
    field :rating, :decimal

    has_many :stock_items, Demo.Inventory.StockItem

    timestamps(type: :utc_datetime)
  end

  def changeset(supplier, attrs) do
    supplier
    |> cast(attrs, [:name, :contact_name, :email, :rating])
    |> validate_required([:name, :contact_name, :email])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> unique_constraint(:email)
  end
end
