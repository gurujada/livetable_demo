defmodule Demo.Catalog.ProductsSuppliers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products_suppliers" do
    belongs_to :product, Demo.Catalog.Product
    belongs_to :supplier, Demo.Catalog.Supplier

    timestamps()
  end

  def changeset(product_supplier, attrs) do
    product_supplier
    |> cast(attrs, [:product_id, :supplier_id])
    |> validate_required([:product_id, :supplier_id])
    |> unique_constraint([:product_id, :supplier_id])
  end
end
