defmodule Demo.Employees.Employee do
  @moduledoc """
  Schema for Demo 3: Range Filters - Employees
  2,000 rows demonstrating range filters for salary and experience.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "demo_employees" do
    field :employee_id, :string
    field :name, :string
    field :email, :string
    field :department, :string
    field :designation, :string
    field :salary, :decimal
    field :experience_years, :integer
    field :is_active, :boolean, default: true
    field :joining_date, :date

    timestamps(type: :utc_datetime)
  end

  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [
      :employee_id,
      :name,
      :email,
      :department,
      :designation,
      :salary,
      :experience_years,
      :is_active,
      :joining_date
    ])
    |> validate_required([
      :employee_id,
      :name,
      :email,
      :department,
      :designation,
      :salary,
      :experience_years,
      :joining_date
    ])
    |> validate_number(:salary, greater_than: 0)
    |> validate_number(:experience_years, greater_than_or_equal_to: 0)
    |> unique_constraint(:employee_id)
    |> unique_constraint(:email)
  end
end
