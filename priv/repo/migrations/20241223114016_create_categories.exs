defmodule Demo.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end

    # Add category_id to products table
    alter table(:products) do
      add :category_id, references(:categories, on_delete: :nothing)
    end

    # Optional: Add index for better query performance
    create index(:products, [:category_id])
  end
end
