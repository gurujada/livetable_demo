defmodule Demo.Events do
  import Ecto.Query
  alias Demo.Repo
  alias Demo.Events.{Event, Registration}

  def list_events() do
    from e in Event,
      join: r in Registration, as: :registrations,
      on: r.event_id == e.id,
      group_by: [e.title, e.starts_at],
      select: %{
        title: e.title,
        starts_at: e.starts_at,
        total_registrations: count(r.id),
        latest_registration: max(r.inserted_at),
        waitlist_count: count(r.status == "waitlisted"),
        confirmed_count: count(r.status == "confirmed"),
      }
  end

  def get_event!(id), do: Repo.get!(Event, id)

  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  def list_registrations(event_id) do
    Registration
    |> where([r], r.event_id == ^event_id)
    |> Repo.all()
  end

  def create_registration(attrs \\ %{}) do
    %Registration{}
    |> Registration.changeset(attrs)
    |> Repo.insert()
  end
end
