defmodule Demo.Inventory.StockItem do
  @moduledoc """
  Schema for Demo 7: Computed Fields - Stock Items
  10,000 rows demonstrating computed fields and custom renderers.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory_stock_items" do
    field :sku, :string
    field :name, :string
    field :quantity, :integer
    field :reorder_level, :integer
    field :unit_cost, :decimal
    field :selling_price, :decimal
    field :last_restocked, :date

    belongs_to :warehouse, Demo.Inventory.Warehouse
    belongs_to :supplier, Demo.Inventory.Supplier

    timestamps(type: :utc_datetime)
  end

  def changeset(stock_item, attrs) do
    stock_item
    |> cast(attrs, [
      :sku,
      :name,
      :quantity,
      :reorder_level,
      :unit_cost,
      :selling_price,
      :last_restocked,
      :warehouse_id,
      :supplier_id
    ])
    |> validate_required([
      :sku,
      :name,
      :quantity,
      :reorder_level,
      :unit_cost,
      :selling_price,
      :warehouse_id,
      :supplier_id
    ])
    |> validate_number(:quantity, greater_than_or_equal_to: 0)
    |> validate_number(:reorder_level, greater_than_or_equal_to: 0)
    |> validate_number(:unit_cost, greater_than: 0)
    |> validate_number(:selling_price, greater_than: 0)
    |> foreign_key_constraint(:warehouse_id)
    |> foreign_key_constraint(:supplier_id)
    |> unique_constraint(:sku)
  end
end
