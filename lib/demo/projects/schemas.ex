defmodule Demo.Projects.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clients" do
    field :name, :string
    field :industry, :string
    field :city, :string
    has_many :projects, Demo.Projects.Project
    timestamps(type: :utc_datetime)
  end

  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :industry, :city])
    |> validate_required([:name, :industry, :city])
  end
end

defmodule Demo.Projects.ProjectType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_types" do
    field :name, :string
    has_many :projects, Demo.Projects.Project
    timestamps(type: :utc_datetime)
  end

  def changeset(project_type, attrs) do
    project_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

defmodule Demo.Projects.Project do
  @moduledoc """
  Schema for Demo 9: Card Mode - Projects
  5,000 rows demonstrating card mode and infinite scroll.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string
    field :status, :string
    field :budget, :decimal
    field :spent, :decimal
    field :start_date, :date
    field :end_date, :date
    field :progress, :integer
    field :team_size, :integer
    field :is_featured, :boolean, default: false

    belongs_to :client, Demo.Projects.Client
    belongs_to :project_type, Demo.Projects.ProjectType

    timestamps(type: :utc_datetime)
  end

  def changeset(project, attrs) do
    project
    |> cast(attrs, [
      :name,
      :description,
      :status,
      :budget,
      :spent,
      :start_date,
      :end_date,
      :progress,
      :team_size,
      :is_featured,
      :client_id,
      :project_type_id
    ])
    |> validate_required([
      :name,
      :status,
      :budget,
      :start_date,
      :progress,
      :team_size,
      :client_id,
      :project_type_id
    ])
    |> validate_inclusion(:status, ~w(planning active on_hold completed cancelled))
    |> validate_number(:progress, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> foreign_key_constraint(:client_id)
    |> foreign_key_constraint(:project_type_id)
  end
end
