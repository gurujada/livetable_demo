defmodule Demo.Tasks.Task do
  @moduledoc """
  Schema for Demo 2: Boolean Filters - Tasks
  1,000 rows demonstrating boolean filters.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :assigned_to, :string
    field :is_completed, :boolean, default: false
    field :is_urgent, :boolean, default: false
    field :is_archived, :boolean, default: false
    field :due_date, :date

    timestamps(type: :utc_datetime)
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :title,
      :description,
      :assigned_to,
      :is_completed,
      :is_urgent,
      :is_archived,
      :due_date
    ])
    |> validate_required([:title, :assigned_to, :due_date])
  end
end
