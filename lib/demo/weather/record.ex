defmodule Demo.Weather.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weather_records" do
    field :temperature, :decimal
    field :humidity, :decimal
    field :wind_speed, :decimal
    field :precipitation, :decimal
    field :location, :string
    field :recorded_at, :utc_datetime
    field :weather_condition, :string

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [
      :temperature,
      :humidity,
      :wind_speed,
      :precipitation,
      :location,
      :recorded_at,
      :weather_condition
    ])
    |> validate_required([
      :temperature,
      :humidity,
      :wind_speed,
      :location,
      :recorded_at,
      :weather_condition
    ])
  end
end
