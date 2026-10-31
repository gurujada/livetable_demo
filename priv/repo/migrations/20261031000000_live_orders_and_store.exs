defmodule Demo.Repo.Migrations.LiveOrdersAndStore do
  use Ecto.Migration

  def up do
    execute "DROP TABLE IF EXISTS oban_jobs, oban_peers CASCADE"
    execute "DROP TYPE IF EXISTS oban_job_state"

    for table <- ~w(invoices customers payment_terms tasks demo_employees products_simple)a,
        do: drop_if_exists(table(table))

    create table(:live_orders) do
      add :number, :string, null: false
      add :customer, :string, null: false
      add :city, :string, null: false
      add :amount, :decimal, precision: 10, scale: 2, null: false
      add :status, :string, null: false
      timestamps(type: :utc_datetime_usec)
    end

    create index(:live_orders, [:inserted_at])

    create table(:store_products) do
      add :name, :string, null: false
      add :category, :string, null: false
      add :image, :string, null: false
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :rating, :decimal, precision: 2, scale: 1, null: false
      add :reviews, :integer, null: false
      add :in_stock, :boolean, null: false
      add :is_new, :boolean, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:store_products, [:category])
    create index(:store_products, [:price])
  end

  def down do
    drop table(:store_products)
    drop table(:live_orders)
  end
end
