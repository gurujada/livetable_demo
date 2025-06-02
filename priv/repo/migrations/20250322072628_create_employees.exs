defmodule Demo.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :name, :string
      add :email, :string
      add :department, :string
      add :salary, :decimal, precision: 10, scale: 2
      add :start_date, :date
      add :level, :string
      add :active, :boolean, default: true

      timestamps()
    end

    create index(:employees, [:department])
    create index(:employees, [:level])
  end
end
