defmodule Demo.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :description, :text
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :stock_quantity, :integer, null: false
      add :active, :boolean, default: true
      add :featured, :boolean, default: false
      add :in_stock, :boolean, default: true

      timestamps()
    end

    create index(:products, [:active])
    create index(:products, [:featured])
    create index(:products, [:in_stock])
  end
end
