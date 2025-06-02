defmodule Demo.Seeds.Weather do
  alias Demo.Weather

  def run do
    locations = ["New York", "London", "Tokyo", "Paris", "Sydney"]
    conditions = ["sunny", "cloudy", "rainy", "stormy"]

    for _ <- 1..1000 do
      Weather.create_weather_record(%{
        temperature: :rand.uniform(400) / 10,
        humidity: :rand.uniform(1000) / 10,
        wind_speed: :rand.uniform(500) / 10,
        precipitation: :rand.uniform(1000) / 10,
        location: Enum.random(locations),
        recorded_at: DateTime.add(DateTime.utc_now(), -:rand.uniform(30), :day),
        weather_condition: Enum.random(conditions)
      })
    end
  end
end
