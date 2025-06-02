defmodule Demo.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :stock_quantity, :integer

    field :active, :boolean, default: true
    field :featured, :boolean, default: false
    field :in_stock, :boolean, default: true

    belongs_to :category, Demo.Catalog.Category

    many_to_many :suppliers, Demo.Catalog.Supplier,
      join_through: "products_suppliers",
      on_replace: :delete

    has_one :image, Demo.Catalog.Image
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :description,
      :price,
      :stock_quantity,
      :category_id,
      :active,
      :featured,
      :in_stock
    ])
    |> validate_required([:name, :price, :stock_quantity, :category_id])
  end
end
