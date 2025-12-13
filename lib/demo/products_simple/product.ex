defmodule Demo.ProductsSimple.Product do
  @moduledoc """
  Schema for Demo 4: Select Filters - Products Simple
  3,000 rows demonstrating select filters (single, tags, quick_tags).
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "products_simple" do
    field :sku, :string
    field :name, :string
    field :category, :string
    field :brand, :string
    field :price, :decimal
    field :in_stock, :boolean, default: true
    field :rating, :decimal

    timestamps(type: :utc_datetime)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :name, :category, :brand, :price, :in_stock, :rating])
    |> validate_required([:sku, :name, :category, :brand, :price])
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> unique_constraint(:sku)
  end
end
