# Demo Seeds - Seeds all 10 demo tables
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

# Demo 2: Tasks (1000 rows)
IO.puts("Seeding Demo 2: Tasks (1000 rows)...")

tasks =
  for _ <- 1..1000 do
    %{
      title: SeedData.generate_task_title(),
      description: "Task description for #{SeedData.random_department()} department",
      assigned_to: SeedData.random_full_name(),
      is_completed: SeedData.random_bool(0.3),
      is_urgent: SeedData.random_bool(0.2),
      is_archived: SeedData.random_bool(0.1),
      due_date:
        if(SeedData.random_bool(0.7),
          do: SeedData.random_future_date(60),
          else: SeedData.random_date_in_past(30)
        )
    }
  end

SeedHelpers.insert_batch(Demo.Tasks.Task, tasks)

# Demo 3: Employees (2000 rows)
IO.puts("Seeding Demo 3: Employees (2000 rows)...")

employees =
  for i <- 1..2000 do
    level = Enum.random([:junior, :mid, :senior, :leadership])
    name = SeedData.random_full_name()

    %{
      employee_id: "EMP#{String.pad_leading("#{i}", 5, "0")}",
      name: name,
      email: "emp#{i}@company.com",
      department: SeedData.random_department(),
      designation: SeedData.random_designation(level),
      salary: Decimal.new(SeedData.random_salary(level)),
      experience_years: SeedData.random_experience(level),
      is_active: SeedData.random_bool(0.9),
      joining_date: SeedData.random_date_in_past(365 * 10)
    }
  end

SeedHelpers.insert_batch(Demo.Employees.Employee, employees)

# Demo 4: Products Simple (3000 rows)
IO.puts("Seeding Demo 4: Products Simple (3000 rows)...")

products_simple =
  for i <- 1..3000 do
    category = SeedData.random_product_category()

    %{
      sku: "PRD#{String.pad_leading("#{i}", 6, "0")}",
      name: SeedData.generate_product_name(category),
      category: category,
      brand: SeedData.random_brand(),
      price: SeedData.random_price(500, 50000),
      in_stock: SeedData.random_bool(0.85),
      rating: SeedData.random_rating()
    }
  end

SeedHelpers.insert_batch(Demo.ProductsSimple.Product, products_simple)

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

# Demo 6: Invoices with joins (8000 rows)
IO.puts("Seeding Demo 6: Invoices (8000 rows)...")

# First create customers
IO.puts("  Creating customers...")

customers =
  for i <- 1..500 do
    name = SeedData.random_full_name()
    {city, _state} = SeedData.random_city_state()

    %{
      name: name,
      email: "customer#{i}@invoice.com",
      phone: SeedData.random_phone(),
      city: city
    }
  end

SeedHelpers.insert_batch(Demo.Invoices.Customer, customers)
customer_ids = Repo.all(Demo.Invoices.Customer) |> Enum.map(& &1.id)

# Create payment terms
IO.puts("  Creating payment terms...")

payment_terms =
  SeedData.all_payment_terms()
  |> Enum.map(fn {name, days} ->
    %{name: name, days: days}
  end)

SeedHelpers.insert_batch(Demo.Invoices.PaymentTerm, payment_terms)
payment_term_ids = Repo.all(Demo.Invoices.PaymentTerm) |> Enum.map(& &1.id)

# Create invoices
IO.puts("  Creating invoices...")

invoices =
  for i <- 1..8000 do
    issue_date = SeedData.random_date_in_past(365)
    days_offset = Enum.random([0, 7, 15, 30, 45, 60, 90])
    amount = SeedData.random_price(1000, 500_000)

    %{
      invoice_number: "INV#{Date.utc_today().year}#{String.pad_leading("#{i}", 6, "0")}",
      amount: amount,
      tax_amount: Decimal.mult(amount, Decimal.from_float(0.18)) |> Decimal.round(2),
      status: SeedData.random_invoice_status(),
      issue_date: issue_date,
      due_date: Date.add(issue_date, days_offset),
      customer_id: Enum.random(customer_ids),
      payment_term_id: Enum.random(payment_term_ids)
    }
  end

SeedHelpers.insert_batch(Demo.Invoices.Invoice, invoices)

# Demo 7: Inventory (10000 rows)
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
    unit_cost = SeedData.random_price(100, 5000)
    # 0-50% margin
    margin = Decimal.from_float(1.0 + :rand.uniform() * 0.5)

    %{
      sku: "STK#{String.pad_leading("#{i}", 6, "0")}",
      name: SeedData.generate_product_name(SeedData.random_product_category()),
      quantity: Enum.random(0..1000),
      reorder_level: Enum.random(10..100),
      unit_cost: unit_cost,
      selling_price: Decimal.mult(unit_cost, margin) |> Decimal.round(2),
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

# Demo 10: Flagship (1M rows)
IO.puts("Seeding Demo 10: Flagship (1,000,000 rows)...")
IO.puts("  This will take a few minutes...")

# Create brands
IO.puts("  Creating brands...")

brands =
  SeedData.all_brands()
  |> Enum.map(fn brand ->
    %{
      name: brand,
      country: Enum.random(["India", "USA", "Japan", "South Korea", "China", "Germany", "UK"]),
      is_active: SeedData.random_bool(0.95)
    }
  end)

SeedHelpers.insert_batch(Demo.Flagship.Brand, brands)
brand_ids = Repo.all(Demo.Flagship.Brand) |> Enum.map(& &1.id)

# Create categories
IO.puts("  Creating categories...")

categories =
  SeedData.all_product_categories()
  |> Enum.map(fn cat ->
    %{
      name: cat,
      slug: cat |> String.downcase() |> String.replace(~r/[^a-z0-9]+/, "-")
    }
  end)

SeedHelpers.insert_batch(Demo.Flagship.Category, categories)
category_ids = Repo.all(Demo.Flagship.Category) |> Enum.map(& &1.id)

# Create warehouses for flagship
IO.puts("  Creating flagship warehouses...")

flagship_warehouses =
  SeedData.all_cities_with_states()
  |> Enum.take(30)
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
      name: "Flagship #{city}",
      city: city,
      state: state,
      region: region
    }
  end)

SeedHelpers.insert_batch(Demo.Flagship.FlagshipWarehouse, flagship_warehouses)
flagship_warehouse_ids = Repo.all(Demo.Flagship.FlagshipWarehouse) |> Enum.map(& &1.id)

# Create flagship products
IO.puts("  Creating flagship products (1,000,000 rows in batches)...")

# Generate products in larger batches for efficiency
total_products = 1_000_000
batch_size = 1_000

for batch_num <- 1..div(total_products, batch_size) do
  IO.puts("    Batch #{batch_num}/#{div(total_products, batch_size)}...")

  start_idx = (batch_num - 1) * batch_size + 1
  end_idx = batch_num * batch_size

  products =
    for i <- start_idx..end_idx do
      category = SeedData.random_product_category()
      cost = SeedData.random_price(100, 50000)
      # 10-100% margin
      margin = Decimal.from_float(1.1 + :rand.uniform() * 0.9)

      %{
        sku: "FLG#{String.pad_leading("#{i}", 7, "0")}",
        name: "#{SeedData.generate_product_name(category)} #{i}",
        description:
          "High quality #{String.downcase(category)} product from #{SeedData.random_brand()}",
        price: Decimal.mult(cost, margin) |> Decimal.round(2),
        cost: cost,
        stock_quantity: Enum.random(0..5000),
        status: Enum.random(["active", "active", "active", "active", "draft", "discontinued"]),
        is_featured: SeedData.random_bool(0.05),
        rating: SeedData.random_rating(),
        brand_id: Enum.random(brand_ids),
        category_id: Enum.random(category_ids),
        warehouse_id: Enum.random(flagship_warehouse_ids)
      }
    end

  SeedHelpers.insert_batch(Demo.Flagship.Product, products, 5000)
end

IO.puts("\nDemo seeding complete!")
IO.puts("\nSummary:")
IO.puts("  Demo 1 - Contacts: #{Repo.aggregate(Demo.Contacts.Contact, :count)}")
IO.puts("  Demo 2 - Tasks: #{Repo.aggregate(Demo.Tasks.Task, :count)}")
IO.puts("  Demo 3 - Employees: #{Repo.aggregate(Demo.Employees.Employee, :count)}")
IO.puts("  Demo 4 - Products Simple: #{Repo.aggregate(Demo.ProductsSimple.Product, :count)}")
IO.puts("  Demo 5 - Orders: #{Repo.aggregate(Demo.Orders.Order, :count)}")
IO.puts("  Demo 6 - Invoices: #{Repo.aggregate(Demo.Invoices.Invoice, :count)}")
IO.puts("  Demo 6 - Customers: #{Repo.aggregate(Demo.Invoices.Customer, :count)}")
IO.puts("  Demo 7 - Stock Items: #{Repo.aggregate(Demo.Inventory.StockItem, :count)}")
IO.puts("  Demo 7 - Warehouses: #{Repo.aggregate(Demo.Inventory.Warehouse, :count)}")
IO.puts("  Demo 8 - Leads: #{Repo.aggregate(Demo.Leads.Lead, :count)}")
IO.puts("  Demo 9 - Projects: #{Repo.aggregate(Demo.Projects.Project, :count)}")
IO.puts("  Demo 10 - Flagship Products: #{Repo.aggregate(Demo.Flagship.Product, :count)}")
