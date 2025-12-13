defmodule Demo.Flagship do
  @moduledoc """
  Context for Demo 10: Flagship - 1M Products at scale
  """
  import Ecto.Query
  alias Demo.Repo
  alias Demo.Flagship.{Product, Brand, Category, FlagshipWarehouse}

  def list_products do
    Product
    |> preload([:brand, :category, :warehouse])
    |> Repo.all()
  end

  def get_product!(id) do
    Product
    |> preload([:brand, :category, :warehouse])
    |> Repo.get!(id)
  end

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def count_products, do: Repo.aggregate(Product, :count)

  # Brand functions
  def list_brands, do: Repo.all(from b in Brand, where: b.is_active == true, order_by: b.name)
  def create_brand(attrs), do: %Brand{} |> Brand.changeset(attrs) |> Repo.insert()
  def count_brands, do: Repo.aggregate(Brand, :count)

  # Category functions
  def list_categories, do: Repo.all(from c in Category, order_by: c.name)
  def create_category(attrs), do: %Category{} |> Category.changeset(attrs) |> Repo.insert()
  def count_categories, do: Repo.aggregate(Category, :count)

  # Warehouse functions
  def list_warehouses, do: Repo.all(FlagshipWarehouse)

  def create_warehouse(attrs),
    do: %FlagshipWarehouse{} |> FlagshipWarehouse.changeset(attrs) |> Repo.insert()

  def count_warehouses, do: Repo.aggregate(FlagshipWarehouse, :count)

  def statuses, do: ~w(active draft discontinued)
end
