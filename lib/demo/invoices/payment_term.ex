defmodule Demo.Invoices.PaymentTerm do
  @moduledoc """
  Payment terms lookup for Demo 6: Invoices with joins
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "payment_terms" do
    field :name, :string
    field :days, :integer

    has_many :invoices, Demo.Invoices.Invoice

    timestamps(type: :utc_datetime)
  end

  def changeset(payment_term, attrs) do
    payment_term
    |> cast(attrs, [:name, :days])
    |> validate_required([:name, :days])
    |> validate_number(:days, greater_than_or_equal_to: 0)
    |> unique_constraint(:name)
  end
end
