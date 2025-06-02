defmodule Demo.HR.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :name, :string
    field :email, :string
    field :department, :string
    field :salary, :decimal
    field :start_date, :date
    # "junior", "mid", "senior", "lead"
    field :level, :string
    field :active, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :email, :department, :salary, :start_date, :level, :active])
    |> validate_required([:name, :email, :department, :salary, :start_date, :level])
    |> validate_inclusion(:level, ["junior", "mid", "senior", "lead"])
  end
end
