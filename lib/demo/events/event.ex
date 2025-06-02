defmodule Demo.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :title, :string
    field :description, :string
    field :starts_at, :utc_datetime
    field :registration_deadline, :date
    field :status, :string
    field :max_participants, :integer
    field :virtual, :boolean, default: false

    has_many :registrations, Demo.Events.Registration

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :title,
      :description,
      :starts_at,
      :registration_deadline,
      :status,
      :max_participants,
      :virtual
    ])
    |> validate_required([:title, :starts_at, :registration_deadline, :status])
  end
end
