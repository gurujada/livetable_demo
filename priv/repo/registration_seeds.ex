defmodule Demo.Seeds.Registrations do
  alias Demo.Events
  alias Events.{Event, Registration}
  alias Demo.Repo
  import Ecto.Query

  def run do
    # Repo.delete_all(Registration)
    events = Repo.all(Event)

    for event <- events do
      registration_count = Enum.random(5..20)

      for _ <- 1..registration_count do
        current_registrations = Repo.one(from r in Registration,
          where: r.event_id == ^event.id,
          select: count(r.id))

        status = cond do
          current_registrations >= event.max_participants -> "waitlisted"
          current_registrations >= event.max_participants * 0.9 -> Enum.random(["confirmed", "waitlisted"])
          true -> Enum.random(["confirmed", "cancelled", "confirmed", "confirmed"])
        end

        Events.create_registration(%{
          event_id: event.id,
          attendee_name: Faker.Person.name(),
          attendee_email: Faker.Internet.email(),
          status: status
        })
      end
    end

  end
end
