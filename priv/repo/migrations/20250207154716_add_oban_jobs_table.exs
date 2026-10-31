defmodule Demo.Repo.Migrations.AddObanJobsTable do
  use Ecto.Migration

  # Oban was removed; 20261031000000 drops its tables.
  def up, do: :ok
  def down, do: :ok
end
