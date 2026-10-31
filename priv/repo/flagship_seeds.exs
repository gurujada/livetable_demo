# Seeds the flagship demo. Runs as part of demo_seeds.exs, or alone to reseed it. It seeds
# 100,000 products; the live site has a million:
#
#     FLAGSHIP_ROWS=1000000 mix run priv/repo/flagship_seeds.exs

alias Demo.Repo
alias Demo.SeedData
alias Demo.Flagship.{Brand, Category, FlagshipWarehouse, Product}

rows = String.to_integer(System.get_env("FLAGSHIP_ROWS", "100000"))
IO.puts("Seeding the flagship demo (#{rows} products)...")

Repo.query!(
  "TRUNCATE flagship_products, flagship_brands, flagship_categories, flagship_warehouses RESTART IDENTITY"
)

now = DateTime.utc_now() |> DateTime.truncate(:second)
stamp = &Map.merge(&1, %{inserted_at: now, updated_at: now})

Repo.insert_all(
  Brand,
  for({name, country} <- SeedData.brands(), do: stamp.(%{name: name, country: country}))
)

Repo.insert_all(
  Category,
  for name <- SeedData.product_categories() do
    stamp.(%{name: name, slug: name |> String.downcase() |> String.replace(~r/[^a-z0-9]+/, "-")})
  end
)

Repo.insert_all(
  FlagshipWarehouse,
  for {city, state} <- Enum.take(SeedData.all_cities_with_states(), 30) do
    stamp.(%{name: "#{city} Warehouse", city: city, state: state, region: state})
  end
)

brand_ids = Map.new(Repo.all(Brand), &{&1.name, &1.id})
category_ids = Map.new(Repo.all(Category), &{&1.name, &1.id})
warehouse_ids = Enum.map(Repo.all(FlagshipWarehouse), & &1.id)

product = fn i ->
  p = SeedData.random_product()
  roll = :rand.uniform()

  status =
    cond do
      roll < 0.86 -> "active"
      roll < 0.93 -> "draft"
      true -> "discontinued"
    end

  stock =
    cond do
      status == "discontinued" and :rand.uniform() < 0.7 -> 0
      :rand.uniform() < 0.05 -> 0
      :rand.uniform() < 0.25 -> Enum.random(1..20)
      true -> Enum.random(20..1500)
    end

  stamp.(%{
    sku:
      "#{p.brand |> String.replace(~r/[^A-Za-z]/, "") |> String.slice(0, 3) |> String.upcase()}-#{String.pad_leading("#{i}", 7, "0")}",
    name: p.name,
    description: "#{p.name}, by #{p.brand}",
    price: p.price,
    cost: p.cost,
    stock_quantity: stock,
    status: status,
    is_featured: :rand.uniform() < 0.03,
    rating: p.rating,
    brand_id: brand_ids[p.brand],
    category_id: category_ids[p.category],
    warehouse_id: Enum.random(warehouse_ids)
  })
end

# 14 columns, so 4,000 rows stays under Postgres's 65,535 parameters per query.
1..rows
|> Stream.chunk_every(4000)
|> Enum.each(fn ids ->
  Repo.insert_all(Product, Enum.map(ids, product))
  if rem(List.last(ids), 100_000) == 0, do: IO.puts("  #{List.last(ids)}")
end)
