defmodule Demo.ProductsSimple do
  @moduledoc """
  Context for Demo 4: Products Simple - Select Filters
  """
  alias Demo.Repo
  alias Demo.ProductsSimple.Product

  def list_products do
    Repo.all(Product)
  end

  def get_product!(id), do: Repo.get!(Product, id)

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def count_products do
    Repo.aggregate(Product, :count)
  end

  def categories do
    Demo.SeedData.all_product_categories()
  end

  def brands do
    Demo.SeedData.all_brands()
  end
end
