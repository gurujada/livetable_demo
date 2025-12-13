defmodule Demo.Inventory do
  @moduledoc """
  Context for Demo 7: Inventory - Computed Fields
  """
  import Ecto.Query
  alias Demo.Repo
  alias Demo.Inventory.{StockItem, Warehouse, Supplier}

  def list_stock_items do
    StockItem
    |> preload([:warehouse, :supplier])
    |> Repo.all()
  end

  def get_stock_item!(id) do
    StockItem
    |> preload([:warehouse, :supplier])
    |> Repo.get!(id)
  end

  def create_stock_item(attrs \\ %{}) do
    %StockItem{}
    |> StockItem.changeset(attrs)
    |> Repo.insert()
  end

  def count_stock_items, do: Repo.aggregate(StockItem, :count)

  # Warehouse functions
  def list_warehouses, do: Repo.all(Warehouse)
  def get_warehouse!(id), do: Repo.get!(Warehouse, id)

  def create_warehouse(attrs \\ %{}) do
    %Warehouse{}
    |> Warehouse.changeset(attrs)
    |> Repo.insert()
  end

  def count_warehouses, do: Repo.aggregate(Warehouse, :count)

  # Supplier functions
  def list_suppliers, do: Repo.all(Supplier)
  def get_supplier!(id), do: Repo.get!(Supplier, id)

  def create_supplier(attrs \\ %{}) do
    %Supplier{}
    |> Supplier.changeset(attrs)
    |> Repo.insert()
  end

  def count_suppliers, do: Repo.aggregate(Supplier, :count)
end
