defmodule Demo.Leads do
  @moduledoc """
  Context for Demo 8: Leads - Transformers
  """
  import Ecto.Query
  alias Demo.Repo
  alias Demo.Leads.{Lead, Source, Stage, SalesRep}

  def list_leads do
    Lead
    |> preload([:source, :stage, :sales_rep])
    |> Repo.all()
  end

  def get_lead!(id) do
    Lead
    |> preload([:source, :stage, :sales_rep])
    |> Repo.get!(id)
  end

  def create_lead(attrs \\ %{}) do
    %Lead{}
    |> Lead.changeset(attrs)
    |> Repo.insert()
  end

  def count_leads, do: Repo.aggregate(Lead, :count)

  # Source functions
  def list_sources, do: Repo.all(Source)
  def create_source(attrs), do: %Source{} |> Source.changeset(attrs) |> Repo.insert()
  def count_sources, do: Repo.aggregate(Source, :count)

  # Stage functions
  def list_stages, do: Repo.all(from s in Stage, order_by: s.position)
  def create_stage(attrs), do: %Stage{} |> Stage.changeset(attrs) |> Repo.insert()
  def count_stages, do: Repo.aggregate(Stage, :count)

  def search_stages(text) do
    Stage
    |> where([s], ilike(s.name, ^"%#{text}%"))
    |> order_by([s], s.position)
    |> select([s], {s.name, [s.id]})
    |> Repo.all()
  end

  # Sales rep functions
  def list_sales_reps, do: Repo.all(from sr in SalesRep, where: sr.is_active == true)
  def create_sales_rep(attrs), do: %SalesRep{} |> SalesRep.changeset(attrs) |> Repo.insert()
  def count_sales_reps, do: Repo.aggregate(SalesRep, :count)
end
