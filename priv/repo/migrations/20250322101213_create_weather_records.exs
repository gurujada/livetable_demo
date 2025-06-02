defmodule Demo.Repo.Migrations.CreateWeatherRecords do
  use Ecto.Migration

  def change do
    create table(:weather_records) do
      add :temperature, :decimal, precision: 5, scale: 2
      add :humidity, :decimal, precision: 5, scale: 2
      add :wind_speed, :decimal, precision: 5, scale: 2
      add :precipitation, :decimal, precision: 5, scale: 2
      add :location, :string
      add :recorded_at, :utc_datetime
      add :weather_condition, :string

      timestamps()
    end

    create index(:weather_records, [:location])
    create index(:weather_records, [:recorded_at])
  end
end
