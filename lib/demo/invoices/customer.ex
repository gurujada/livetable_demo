defmodule Demo.Invoices.Customer do
  @moduledoc """
  Customer schema for Demo 6: Invoices with joins
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :city, :string

    has_many :invoices, Demo.Invoices.Invoice

    timestamps(type: :utc_datetime)
  end

  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :phone, :city])
    |> validate_required([:name, :email, :phone, :city])
    |> unique_constraint(:email)
  end
end
