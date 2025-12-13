defmodule Demo.Invoices.Invoice do
  @moduledoc """
  Schema for Demo 6: Joins & Associations - Invoices
  8,000 rows demonstrating multi-table joins.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :invoice_number, :string
    field :amount, :decimal
    field :tax_amount, :decimal
    field :status, :string
    field :issue_date, :date
    field :due_date, :date

    belongs_to :customer, Demo.Invoices.Customer
    belongs_to :payment_term, Demo.Invoices.PaymentTerm

    timestamps(type: :utc_datetime)
  end

  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :invoice_number,
      :amount,
      :tax_amount,
      :status,
      :issue_date,
      :due_date,
      :customer_id,
      :payment_term_id
    ])
    |> validate_required([
      :invoice_number,
      :amount,
      :status,
      :issue_date,
      :due_date,
      :customer_id,
      :payment_term_id
    ])
    |> validate_inclusion(:status, ~w(draft sent paid overdue cancelled))
    |> foreign_key_constraint(:customer_id)
    |> foreign_key_constraint(:payment_term_id)
    |> unique_constraint(:invoice_number)
  end
end
