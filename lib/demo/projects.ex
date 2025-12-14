defmodule Demo.Projects do
  @moduledoc """
  Context for Demo 9: Projects - Card Mode
  """
  import Ecto.Query
  alias Demo.Repo
  alias Demo.Projects.{Project, Client, ProjectType}

  def list_projects do
    Project
    |> preload([:client, :project_type])
    |> Repo.all()
  end

  def get_project!(id) do
    Project
    |> preload([:client, :project_type])
    |> Repo.get!(id)
  end

  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  def count_projects, do: Repo.aggregate(Project, :count)

  # Client functions
  def list_clients, do: Repo.all(Client)
  def create_client(attrs), do: %Client{} |> Client.changeset(attrs) |> Repo.insert()
  def count_clients, do: Repo.aggregate(Client, :count)

  # Project type functions
  def list_project_types, do: Repo.all(ProjectType)

  def create_project_type(attrs),
    do: %ProjectType{} |> ProjectType.changeset(attrs) |> Repo.insert()

  def count_project_types, do: Repo.aggregate(ProjectType, :count)

  def search_project_types(text) do
    ProjectType
    |> where([pt], ilike(pt.name, ^"%#{text}%"))
    |> order_by([pt], pt.name)
    |> select([pt], {pt.name, [pt.id]})
    |> Repo.all()
  end

  def statuses, do: ~w(planning active on_hold completed cancelled)
end
