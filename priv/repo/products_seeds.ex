defmodule Demo.Seeds.Products do
  alias Demo.Repo
  alias Demo.Catalog.{Category, Product, Supplier, Image}

  def run do

    batch_size = 1000
    total_products = 1000
    max_concurrency = 4

    categories = create_categories()
    suppliers = create_suppliers()
    create_products(categories, suppliers, batch_size, total_products, max_concurrency)

  end

  defp create_categories do
    [
      "Electronics",
      "Clothing",
      "Books",
      "Food",
      "Home & Kitchen",
      "Beauty & Personal Care",
      "Sports & Fitness",
      "Toys & Games",
      "Health & Wellness",
      "Automotive"
    ]
    |> Enum.map(fn name ->
      Category.changeset(%Category{}, %{
        name: name,
        description: "Quality #{name} from trusted brands"
      })
      |> Repo.insert!()
    end)
  end

  def get_product_details(category_name) do
    case category_name do
      "Electronics" ->
        {Enum.random(["iPhone 14", "Samsung Galaxy S23", "MacBook Pro", "Dell XPS", "iPad Air"]),
         Enum.random(30000..150_000),
         "High-quality device with premium features. Includes warranty and after-sales support."}

      "Clothing" ->
        {Enum.random(["Cotton T-Shirt", "Denim Jeans", "Formal Shirt", "Winter Jacket"]),
         Enum.random(499..3999), "Comfortable fit with premium fabric quality. Machine washable."}

      "Books" ->
        {Enum.random([
           "The Silent Patient",
           "Atomic Habits",
           "Rich Dad Poor Dad",
           "Think and Grow Rich"
         ]), Enum.random(199..999),
         "Bestseller with excellent reader reviews. Available in paperback and hardcover."}

      "Food" ->
        {Enum.random(["Organic Honey", "Premium Coffee Beans", "Dark Chocolate", "Dried Fruits"]),
         Enum.random(99..999), "100% natural ingredients. No artificial preservatives."}

      _ ->
        {Enum.random(["Generic Item", "Basic Product"]), Enum.random(99..999),
         "Standard quality product with good value for money."}
    end
  end

  def indian_supplier_names do
    [
      "Reliance Industries",
      "Tata Enterprises",
      "Birla Corporation",
      "Mahindra Supplies",
      "Infosys Solutions",
      "Wipro Limited",
      "HCL Technologies",
      "Bajaj Electronics",
      "Godrej Industries",
      "ITC Limited",
      "Dabur India",
      "Hindustan Unilever",
      "Patanjali Ayurved",
      "Asian Paints",
      "Bharti Airtel"
    ]
  end

  defp create_suppliers do
    indian_supplier_names()
    |> Enum.map(fn company_name ->
      Supplier.changeset(%Supplier{}, %{
        name: company_name,
        contact_info: "support@#{String.downcase(String.replace(company_name, " ", ""))}.in",
        address: "#{Faker.Address.street_address()}, #{Enum.random(["Mumbai", "Delhi", "Bangalore", "Chennai", "Hyderabad"])}, India"
      })
      |> Repo.insert!()
    end)
  end

  defp create_products(categories, suppliers, batch_size, total_products, max_concurrency) do
    1..div(total_products, batch_size)
    |> Task.async_stream(
      fn batch_number ->
        Repo.transaction(
          fn ->
            products =
              Enum.map(1..batch_size, fn _ ->
                category = Enum.random(categories)
                {product_name, price_range, description} = get_product_details(category.name)
                price = Decimal.from_float((price_range / 100) |> Float.round(2))

                product =
                  Product.changeset(%Product{}, %{
                    name: product_name,
                    description: description,
                    price: price,
                    stock_quantity: :rand.uniform(1000),
                    active: :rand.uniform(10) > 2,
                    featured: :rand.uniform(10) > 8,
                    in_stock: :rand.uniform(10) > 3,
                    category_id: category.id
                  })
                  |> Repo.insert!()

                Image.changeset(%Image{}, %{
                  url: "https://picsum.photos/seed/#{product.id}/400/300",
                  product_id: product.id
                })
                |> Repo.insert!()

                Enum.take_random(suppliers, :rand.uniform(3))
                |> Enum.each(fn supplier ->
                  Repo.insert_all("products_suppliers", [
                    %{
                      product_id: product.id,
                      supplier_id: supplier.id,
                      inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
                      updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
                    }
                  ])
                end)

                product
              end)

            IO.puts("Completed batch #{batch_number}/#{div(total_products, batch_size)}")
            length(products)
          end,
          timeout: :infinity
        )
      end,
      max_concurrency: max_concurrency,
      timeout: :infinity
    )
    |> Stream.run()
  end


end
