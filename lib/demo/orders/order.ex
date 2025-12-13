defmodule Demo.Orders.Order do
  @moduledoc """
  Schema for Demo 5: Multiple Filters Combined - Orders
  5,000 rows demonstrating all filter types combined.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :order_number, :string
    field :customer_name, :string
    field :customer_email, :string
    field :status, :string
    field :payment_status, :string
    field :total_amount, :decimal
    field :items_count, :integer
    field :city, :string
    field :state, :string
    field :is_express, :boolean, default: false
    field :is_gift, :boolean, default: false
    field :order_date, :date

    timestamps(type: :utc_datetime)
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :order_number,
      :customer_name,
      :customer_email,
      :status,
      :payment_status,
      :total_amount,
      :items_count,
      :city,
      :state,
      :is_express,
      :is_gift,
      :order_date
    ])
    |> validate_required([
      :order_number,
      :customer_name,
      :customer_email,
      :status,
      :payment_status,
      :total_amount,
      :items_count,
      :city,
      :state,
      :order_date
    ])
    |> validate_inclusion(:status, ~w(pending confirmed shipped delivered cancelled))
    |> validate_inclusion(:payment_status, ~w(pending paid refunded partially_paid))
    |> unique_constraint(:order_number)
  end
end
