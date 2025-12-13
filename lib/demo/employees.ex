defmodule Demo.Employees do
  @moduledoc """
  Context for Demo 3: Employees - Range Filters
  """
  alias Demo.Repo
  alias Demo.Employees.Employee

  def list_employees do
    Repo.all(Employee)
  end

  def get_employee!(id), do: Repo.get!(Employee, id)

  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end

  def count_employees do
    Repo.aggregate(Employee, :count)
  end
end
