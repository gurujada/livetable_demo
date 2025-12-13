defmodule Demo.Contacts.Contact do
  @moduledoc """
  Schema for Demo 1: Basic Table - Contacts
  500 rows demonstrating sorting, pagination, and search.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :city, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :phone, :city])
    |> validate_required([:name, :email, :phone, :city])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
