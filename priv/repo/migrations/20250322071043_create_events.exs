defmodule Demo.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :description, :text
      add :starts_at, :utc_datetime
      add :ends_at, :utc_datetime
      add :status, :string
      add :max_participants, :integer
      add :virtual, :boolean, default: false
      add :registration_deadline, :date
      timestamps()
    end

    create index(:events, [:status])
    create index(:events, [:starts_at])
  end
end
