defmodule Demo.Catalog do
  import Ecto.Query

  alias Demo.{
    Repo,
    Catalog.Supplier,
    Catalog.Category,
    Catalog.Product,
    Catalog.ProductsSuppliers,
    Catalog.Image
  }

  def list_products() do
    from p in Product,
      as: :product,
      join: c in Category,
      as: :category,
      on: p.category_id == c.id,
      join: ps in ProductsSuppliers,
      on: p.id == ps.product_id,
      join: s in Supplier,
      as: :suppliers,
      on: ps.supplier_id == s.id,
      join: i in Image,
      on: p.id == i.product_id,
      select: %{
        id: p.id,
        name: p.name,
        price: p.price,
        description: p.description,
        supplier_name: s.name,
        category_name: c.name,
        stock_quantity: p.stock_quantity,
        category_name: c.name,
        supplier_contact: s.contact_info,
        category_description: c.description,
        image: i.url,
        amount: fragment("? * ?", p.price, p.stock_quantity)
      }
  end

  def list_products_select() do
    from p in Product,
      join: c in Category,
      as: :category,
      on: p.category_id == c.id,
      join: ps in ProductsSuppliers,
      on: p.id == ps.product_id,
      join: s in Supplier,
      as: :supplier,
      on: ps.supplier_id == s.id,
      select: %{
        id: p.id,
        name: p.name,
        price: p.price,
        supplier: s.name,
        category_name: c.name,
        stock_quantity: p.stock_quantity
      }
  end

  def search_suppliers(text) do
    Supplier
    |> where([c], ilike(c.name, ^"%#{text}%"))
    |> select([c], {c.name, [c.id, c.contact_info]})
    |> Repo.all()
  end

  def search_categories(text) do
    Category
    |> where([c], ilike(c.name, ^"%#{text}%"))
    |> select([c], {c.name, [c.id, c.description]})
    |> Repo.all()
  end
end
