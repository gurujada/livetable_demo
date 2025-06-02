defmodule Demo.Catalog.Supplier do
  use Ecto.Schema
  import Ecto.Changeset

  schema "suppliers" do
    field :name, :string
    field :contact_info, :string
    field :address, :string

    many_to_many :products, Demo.Catalog.Product,
      join_through: "products_suppliers",
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  def changeset(supplier, attrs) do
    supplier
    |> cast(attrs, [:name, :contact_info, :address])
    |> validate_required([:name])
  end
end
