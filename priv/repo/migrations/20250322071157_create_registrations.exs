defmodule Demo.Repo.Migrations.CreateRegistrations do
  use Ecto.Migration

  def change do
    create table(:registrations) do
      add :attendee_name, :string
      add :attendee_email, :string
      # "confirmed", "cancelled", "waitlisted"
      add :status, :string
      add :event_id, references(:events, on_delete: :delete_all)

      timestamps()
    end

    create index(:registrations, [:event_id])
    create index(:registrations, [:status])
  end
end
