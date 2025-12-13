defmodule Demo.Invoices do
  @moduledoc """
  Context for Demo 6: Invoices - Joins & Associations
  """
  import Ecto.Query
  alias Demo.Repo
  alias Demo.Invoices.{Invoice, Customer, PaymentTerm}

  def list_invoices do
    Invoice
    |> preload([:customer, :payment_term])
    |> Repo.all()
  end

  def get_invoice!(id) do
    Invoice
    |> preload([:customer, :payment_term])
    |> Repo.get!(id)
  end

  def create_invoice(attrs \\ %{}) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  def count_invoices, do: Repo.aggregate(Invoice, :count)

  # Customer functions
  def list_customers, do: Repo.all(Customer)
  def get_customer!(id), do: Repo.get!(Customer, id)

  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  def count_customers, do: Repo.aggregate(Customer, :count)

  # Payment term functions
  def list_payment_terms, do: Repo.all(PaymentTerm)
  def get_payment_term!(id), do: Repo.get!(PaymentTerm, id)

  def create_payment_term(attrs \\ %{}) do
    %PaymentTerm{}
    |> PaymentTerm.changeset(attrs)
    |> Repo.insert()
  end

  def statuses, do: ~w(draft sent paid overdue cancelled)
end
