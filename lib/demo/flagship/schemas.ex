defmodule Demo.Flagship.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flagship_brands" do
    field :name, :string
    field :country, :string
    field :is_active, :boolean, default: true
    has_many :products, Demo.Flagship.Product
    timestamps(type: :utc_datetime)
  end

  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name, :country, :is_active])
    |> validate_required([:name, :country])
    |> unique_constraint(:name)
  end
end

defmodule Demo.Flagship.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flagship_categories" do
    field :name, :string
    field :slug, :string
    has_many :products, Demo.Flagship.Product
    timestamps(type: :utc_datetime)
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end
end

defmodule Demo.Flagship.FlagshipWarehouse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flagship_warehouses" do
    field :name, :string
    field :city, :string
    field :state, :string
    field :region, :string
    has_many :products, Demo.Flagship.Product, foreign_key: :warehouse_id
    timestamps(type: :utc_datetime)
  end

  def changeset(warehouse, attrs) do
    warehouse
    |> cast(attrs, [:name, :city, :state, :region])
    |> validate_required([:name, :city, :state, :region])
    |> unique_constraint(:name)
  end
end

defmodule Demo.Flagship.Product do
  @moduledoc """
  Schema for Demo 10: Flagship - 1M Products
  1,000,000 rows demonstrating all features at scale.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "flagship_products" do
    field :sku, :string
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :cost, :decimal
    field :stock_quantity, :integer
    field :status, :string
    field :is_featured, :boolean, default: false
    field :rating, :decimal

    belongs_to :brand, Demo.Flagship.Brand
    belongs_to :category, Demo.Flagship.Category
    belongs_to :warehouse, Demo.Flagship.FlagshipWarehouse

    timestamps(type: :utc_datetime)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :sku,
      :name,
      :description,
      :price,
      :cost,
      :stock_quantity,
      :status,
      :is_featured,
      :rating,
      :brand_id,
      :category_id,
      :warehouse_id
    ])
    |> validate_required([
      :sku,
      :name,
      :price,
      :cost,
      :stock_quantity,
      :status,
      :brand_id,
      :category_id,
      :warehouse_id
    ])
    |> validate_inclusion(:status, ~w(active draft discontinued))
    |> validate_number(:price, greater_than: 0)
    |> validate_number(:cost, greater_than: 0)
    |> validate_number(:stock_quantity, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:brand_id)
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:warehouse_id)
    |> unique_constraint(:sku)
  end
end
