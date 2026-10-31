# Demo Seeds - Seeds every demo table except the live feed, which fills itself
# Run with: mix run priv/repo/demo_seeds.exs

alias Demo.Repo
alias Demo.SeedData

IO.puts("Starting demo seeding...")

# Helper to insert in batches for performance
defmodule SeedHelpers do
  def insert_batch(schema, records, batch_size \\ 1000) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    records
    |> Enum.map(&Map.merge(&1, %{inserted_at: now, updated_at: now}))
    |> Enum.chunk_every(batch_size)
    |> Enum.each(fn batch ->
      Demo.Repo.insert_all(schema, batch)
    end)
  end
end

# Demo 1: Contacts (500 rows)
IO.puts("Seeding Demo 1: Contacts (500 rows)...")

contacts =
  for _ <- 1..500 do
    name = SeedData.random_full_name()
    {city, _state} = SeedData.random_city_state()

    %{
      name: name,
      email: SeedData.random_email(name) <> "#{:rand.uniform(9999)}",
      phone: SeedData.random_phone(),
      city: city
    }
  end

SeedHelpers.insert_batch(Demo.Contacts.Contact, contacts)

# Demo 5: Orders (5000 rows)
IO.puts("Seeding Demo 5: Orders (5000 rows)...")

orders =
  for i <- 1..5000 do
    {city, state} = SeedData.random_city_state()

    %{
      order_number: "ORD#{Date.utc_today().year}#{String.pad_leading("#{i}", 6, "0")}",
      customer_name: SeedData.random_full_name(),
      customer_email: "customer#{i}@email.com",
      status: SeedData.random_order_status(),
      payment_status: SeedData.random_payment_status(),
      total_amount: SeedData.random_price(500, 100_000),
      items_count: Enum.random(1..10),
      city: city,
      state: state,
      is_express: SeedData.random_bool(0.15),
      is_gift: SeedData.random_bool(0.1),
      order_date: SeedData.random_date_in_past(180)
    }
  end

SeedHelpers.insert_batch(Demo.Orders.Order, orders)

# Storefront (360 rows)
IO.puts("Seeding Storefront (360 rows)...")

makers = ~w(Aero Nova Kite Halo Field Tide Ember Atlas Willow Cobalt Juniper Sable)

store_products =
  for category <- Demo.Store.Product.categories(), _ <- 1..60 do
    {image, item, prices} = Enum.random(Demo.Store.Product.items(category))

    %{
      name: "#{Enum.random(makers)} #{item}",
      category: category,
      image: image,
      price: Decimal.new(div(Enum.random(prices), 100) * 100 - 1),
      rating: Decimal.from_float(Float.round(3.4 + :rand.uniform() * 1.6, 1)),
      reviews: Enum.random(3..2400),
      in_stock: SeedData.random_bool(0.85),
      is_new: SeedData.random_bool(0.15)
    }
  end

SeedHelpers.insert_batch(Demo.Store.Product, store_products)

IO.puts("Seeding Demo 7: Inventory (10000 rows)...")

# Create warehouses
IO.puts("  Creating warehouses...")

warehouses =
  SeedData.all_cities_with_states()
  |> Enum.take(20)
  |> Enum.map(fn {city, state} ->
    region =
      case state do
        s when s in ["Maharashtra", "Gujarat", "Rajasthan", "Goa"] ->
          "West"

        s when s in ["Tamil Nadu", "Karnataka", "Kerala", "Andhra Pradesh", "Telangana"] ->
          "South"

        s when s in ["West Bengal", "Bihar", "Jharkhand", "Odisha", "Assam"] ->
          "East"

        s
        when s in [
               "Delhi",
               "Uttar Pradesh",
               "Punjab",
               "Haryana",
               "Uttarakhand",
               "Himachal Pradesh",
               "Chandigarh",
               "Jammu & Kashmir"
             ] ->
          "North"

        _ ->
          "Central"
      end

    %{
      name: "#{city} Warehouse",
      city: city,
      state: state,
      region: region
    }
  end)

SeedHelpers.insert_batch(Demo.Inventory.Warehouse, warehouses)
warehouse_ids = Repo.all(Demo.Inventory.Warehouse) |> Enum.map(& &1.id)

# Create suppliers
IO.puts("  Creating suppliers...")

suppliers =
  for i <- 1..50 do
    name = SeedData.random_company_name()

    %{
      name: name,
      contact_name: SeedData.random_full_name(),
      email: "supplier#{i}@supply.com",
      rating: SeedData.random_rating()
    }
  end

SeedHelpers.insert_batch(Demo.Inventory.Supplier, suppliers)
supplier_ids = Repo.all(Demo.Inventory.Supplier) |> Enum.map(& &1.id)

# Create stock items
IO.puts("  Creating stock items...")

stock_items =
  for i <- 1..10000 do
    product = SeedData.random_product()

    %{
      sku: "STK#{String.pad_leading("#{i}", 6, "0")}",
      name: product.name,
      quantity: Enum.random(0..1000),
      reorder_level: Enum.random(10..100),
      unit_cost: product.cost,
      selling_price: product.price,
      last_restocked:
        if(SeedData.random_bool(0.8), do: SeedData.random_date_in_past(90), else: nil),
      warehouse_id: Enum.random(warehouse_ids),
      supplier_id: Enum.random(supplier_ids)
    }
  end

SeedHelpers.insert_batch(Demo.Inventory.StockItem, stock_items)

# Demo 8: Leads (15000 rows)
IO.puts("Seeding Demo 8: Leads (15000 rows)...")

# Create lead sources
IO.puts("  Creating lead sources...")

lead_sources =
  SeedData.all_lead_sources()
  |> Enum.map(&%{name: &1})

SeedHelpers.insert_batch(Demo.Leads.Source, lead_sources)
source_ids = Repo.all(Demo.Leads.Source) |> Enum.map(& &1.id)

# Create lead stages
IO.puts("  Creating lead stages...")

lead_stages =
  SeedData.all_lead_stages()
  |> Enum.with_index(1)
  |> Enum.map(fn {name, position} ->
    %{name: name, position: position, is_active: true}
  end)

SeedHelpers.insert_batch(Demo.Leads.Stage, lead_stages)
stage_ids = Repo.all(Demo.Leads.Stage) |> Enum.map(& &1.id)

# Create sales reps
IO.puts("  Creating sales reps...")

sales_reps =
  for i <- 1..30 do
    %{
      name: SeedData.random_full_name(),
      email: "sales#{i}@company.com",
      territory: SeedData.random_region(),
      is_active: SeedData.random_bool(0.9)
    }
  end

SeedHelpers.insert_batch(Demo.Leads.SalesRep, sales_reps)
sales_rep_ids = Repo.all(Demo.Leads.SalesRep) |> Enum.map(& &1.id)

# Create leads
IO.puts("  Creating leads...")

leads =
  for i <- 1..15000 do
    name = SeedData.random_full_name()

    %{
      name: name,
      email: "lead#{i}@prospect.com",
      phone: if(SeedData.random_bool(0.7), do: SeedData.random_phone(), else: nil),
      company_name: SeedData.random_company_name(),
      deal_value: SeedData.random_price(10000, 5_000_000),
      is_hot: SeedData.random_bool(0.15),
      last_contacted_at:
        if(SeedData.random_bool(0.8), do: SeedData.random_datetime_in_past(60), else: nil),
      notes:
        if(SeedData.random_bool(0.5),
          do: "Follow up required for #{SeedData.random_product_category()}",
          else: nil
        ),
      source_id: Enum.random(source_ids),
      stage_id: Enum.random(stage_ids),
      sales_rep_id: Enum.random(sales_rep_ids)
    }
  end

SeedHelpers.insert_batch(Demo.Leads.Lead, leads)

# Demo 9: Projects (5000 rows)
IO.puts("Seeding Demo 9: Projects (5000 rows)...")

# Create clients
IO.puts("  Creating clients...")
industries = ~w(Technology Finance Healthcare Retail Manufacturing Education Media Consulting)

clients =
  for _i <- 1..200 do
    {city, _state} = SeedData.random_city_state()

    %{
      name: SeedData.random_company_name(),
      industry: Enum.random(industries),
      city: city
    }
  end

SeedHelpers.insert_batch(Demo.Projects.Client, clients)
client_ids = Repo.all(Demo.Projects.Client) |> Enum.map(& &1.id)

# Create project types
IO.puts("  Creating project types...")

project_types =
  SeedData.all_project_types()
  # Ensure uniqueness
  |> Enum.uniq()
  |> Enum.map(&%{name: &1})

SeedHelpers.insert_batch(Demo.Projects.ProjectType, project_types)
project_type_ids = Repo.all(Demo.Projects.ProjectType) |> Enum.map(& &1.id)

# Create projects
IO.puts("  Creating projects...")

projects =
  for i <- 1..5000 do
    budget = SeedData.random_price(100_000, 10_000_000)
    progress = Enum.random(0..100)

    status =
      cond do
        progress == 0 -> "planning"
        progress == 100 -> Enum.random(["completed", "completed", "completed", "cancelled"])
        progress > 0 -> Enum.random(["active", "active", "active", "on_hold"])
        true -> "planning"
      end

    start_date = SeedData.random_date_in_past(365)

    %{
      name: "#{SeedData.generate_project_name()} #{i}",
      description: "Project for #{SeedData.random_department()} department",
      status: status,
      budget: budget,
      spent: Decimal.mult(budget, Decimal.from_float(progress / 100.0)) |> Decimal.round(2),
      start_date: start_date,
      end_date:
        if(status in ["completed", "cancelled"],
          do: Date.add(start_date, Enum.random(30..180)),
          else: nil
        ),
      progress: progress,
      team_size: Enum.random(2..20),
      is_featured: SeedData.random_bool(0.1),
      client_id: Enum.random(client_ids),
      project_type_id: Enum.random(project_type_ids)
    }
  end

SeedHelpers.insert_batch(Demo.Projects.Project, projects)

Code.require_file("flagship_seeds.exs", __DIR__)

IO.puts("\nDemo seeding complete!")
IO.puts("\nSummary:")
IO.puts("  Demo 1 - Contacts: #{Repo.aggregate(Demo.Contacts.Contact, :count)}")
IO.puts("  Demo 5 - Orders: #{Repo.aggregate(Demo.Orders.Order, :count)}")
IO.puts("  Demo 7 - Stock Items: #{Repo.aggregate(Demo.Inventory.StockItem, :count)}")
IO.puts("  Demo 7 - Warehouses: #{Repo.aggregate(Demo.Inventory.Warehouse, :count)}")
IO.puts("  Demo 8 - Leads: #{Repo.aggregate(Demo.Leads.Lead, :count)}")
IO.puts("  Demo 9 - Projects: #{Repo.aggregate(Demo.Projects.Project, :count)}")
IO.puts("  Demo 10 - Flagship Products: #{Repo.aggregate(Demo.Flagship.Product, :count)}")
