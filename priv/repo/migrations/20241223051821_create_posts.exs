defmodule Demo.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :string
      add :likes_count, :integer
      add :repost_count, :integer
      add :photo_locations, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
