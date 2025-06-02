defmodule Demo.HR do
  alias Demo.{Repo, HR.Employee}

  def list_employees do
    Employee
    |> Repo.all()
  end

  def get_employee!(id), do: Repo.get!(Employee, id)

  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end
end