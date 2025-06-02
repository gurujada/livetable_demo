defmodule Demo.Events.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registrations" do
    field :attendee_name, :string
    field :attendee_email, :string
    field :status, :string

    belongs_to :event, Demo.Events.Event

    timestamps()
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:attendee_name, :attendee_email, :status, :event_id])
    |> validate_required([:attendee_name, :attendee_email, :status, :event_id])
    |> validate_inclusion(:status, ["confirmed", "cancelled", "waitlisted"])
    |> foreign_key_constraint(:event_id)
  end
end
