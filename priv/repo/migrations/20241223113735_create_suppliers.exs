defmodule Admin.Repo.Migrations.CreateSuppliers do
  use Ecto.Migration

  def change do
    create table(:suppliers) do
      add :name, :string
      add :contact_info, :string
      add :address, :string

      timestamps(type: :utc_datetime)
    end
  end
end
