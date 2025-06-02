defmodule Demo.Seeds.Events do
  alias Demo.{Events, Events.Event, Repo}
  import Ecto.Query

  def run do
    # Repo.delete_all(Event)

    now = DateTime.utc_now()

    # Past events (30 events)
    create_events_for_period(
      "Past Events",
      DateTime.add(now, -60, :day),   # 60 days ago
      DateTime.add(now, -1, :day),    # Yesterday
      30
    )

    # Current/Upcoming events (50 events)
    create_events_for_period(
      "Current/Upcoming Events",
      DateTime.add(now, 1, :hour),    # 1 hour from now
      DateTime.add(now, 30, :day),    # Next 30 days
      50
    )

    # Future events (20 events)
    create_events_for_period(
      "Future Events",
      DateTime.add(now, 31, :day),    # 31 days ahead
      DateTime.add(now, 90, :day),    # 90 days ahead
      20
    )

  end

  defp create_events_for_period(period_name, period_start, period_end, count) do
    for _ <- 1..count do
      random_seconds = :rand.uniform(max(1, DateTime.diff(period_end, period_start, :second)))
      starts_at = DateTime.add(period_start, random_seconds, :second)

      attrs = %{
        title: "#{Faker.Company.name()} #{Faker.Company.suffix()} Event",
        description: Faker.Lorem.paragraph(2..4),
        starts_at: starts_at,
        registration_deadline: calculate_deadline(starts_at),
        status: get_status(starts_at),
        max_participants: Enum.random(20..200),
        virtual: :rand.uniform(2) == 1
      }

      {:ok, _event} = Events.create_event(attrs)
    end
  end

  defp calculate_deadline(event_date) do
    now = DateTime.utc_now()
    days_until_event = DateTime.diff(event_date, now, :day)

    cond do
      days_until_event < 0 ->
        event_date |> DateTime.to_date() |> Date.add(Enum.random(-14..-7))
      days_until_event > 14 ->
        event_date |> DateTime.to_date() |> Date.add(Enum.random(-14..-3))
      true ->
        event_date |> DateTime.to_date() |> Date.add(Enum.random(-3..-1))
    end
  end

  defp get_status(starts_at) do
    now = DateTime.utc_now()
    cond do
      DateTime.compare(starts_at, now) == :lt -> "completed"
      DateTime.diff(starts_at, now, :day) <= 1 -> "ongoing"
      DateTime.diff(starts_at, now, :day) <= 7 -> "upcoming"
      true -> "scheduled"
    end
  end
end
