defmodule Demo.Repo.Migrations.CreateProductsSuppliers do
  use Ecto.Migration

  def change do
    create table(:products_suppliers) do
      add :product_id, references(:products, on_delete: :delete_all)
      add :supplier_id, references(:suppliers, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:products_suppliers, [:product_id, :supplier_id])
  end
end
