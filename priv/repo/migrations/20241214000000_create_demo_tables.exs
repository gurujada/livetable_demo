defmodule Demo.Repo.Migrations.CreateDemoTables do
  use Ecto.Migration

  def change do
    # Demo 1: Contacts (500 rows)
    create table(:contacts) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone, :string, null: false
      add :city, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:contacts, [:email])
    create index(:contacts, [:name])
    create index(:contacts, [:city])

    # Demo 2: Tasks (1K rows)
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :assigned_to, :string, null: false
      add :is_completed, :boolean, default: false
      add :is_urgent, :boolean, default: false
      add :is_archived, :boolean, default: false
      add :due_date, :date, null: false
      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:is_completed])
    create index(:tasks, [:is_urgent])
    create index(:tasks, [:is_archived])
    create index(:tasks, [:due_date])

    # Demo 3: Employees (2K rows)
    create table(:demo_employees) do
      add :employee_id, :string, null: false
      add :name, :string, null: false
      add :email, :string, null: false
      add :department, :string, null: false
      add :designation, :string, null: false
      add :salary, :decimal, null: false
      add :experience_years, :integer, null: false
      add :is_active, :boolean, default: true
      add :joining_date, :date, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:demo_employees, [:employee_id])
    create unique_index(:demo_employees, [:email])
    create index(:demo_employees, [:department])
    create index(:demo_employees, [:salary])
    create index(:demo_employees, [:experience_years])

    # Demo 4: Products Simple (3K rows)
    create table(:products_simple) do
      add :sku, :string, null: false
      add :name, :string, null: false
      add :category, :string, null: false
      add :brand, :string, null: false
      add :price, :decimal, null: false
      add :in_stock, :boolean, default: true
      add :rating, :decimal
      timestamps(type: :utc_datetime)
    end

    create unique_index(:products_simple, [:sku])
    create index(:products_simple, [:category])
    create index(:products_simple, [:brand])
    create index(:products_simple, [:price])
    create index(:products_simple, [:rating])

    # Demo 5: Orders (5K rows)
    create table(:orders) do
      add :order_number, :string, null: false
      add :customer_name, :string, null: false
      add :customer_email, :string, null: false
      add :status, :string, null: false
      add :payment_status, :string, null: false
      add :total_amount, :decimal, null: false
      add :items_count, :integer, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :is_express, :boolean, default: false
      add :is_gift, :boolean, default: false
      add :order_date, :date, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:orders, [:order_number])
    create index(:orders, [:status])
    create index(:orders, [:payment_status])
    create index(:orders, [:total_amount])
    create index(:orders, [:order_date])

    # Demo 6: Invoices with joins (8K rows)
    create table(:customers) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone, :string, null: false
      add :city, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:customers, [:email])

    create table(:payment_terms) do
      add :name, :string, null: false
      add :days, :integer, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:payment_terms, [:name])

    create table(:invoices) do
      add :invoice_number, :string, null: false
      add :amount, :decimal, null: false
      add :tax_amount, :decimal
      add :status, :string, null: false
      add :issue_date, :date, null: false
      add :due_date, :date, null: false
      add :customer_id, references(:customers, on_delete: :restrict), null: false
      add :payment_term_id, references(:payment_terms, on_delete: :restrict), null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:invoices, [:invoice_number])
    create index(:invoices, [:customer_id])
    create index(:invoices, [:payment_term_id])
    create index(:invoices, [:status])
    create index(:invoices, [:amount])

    # Demo 7: Inventory with computed fields (10K rows)
    create table(:inventory_warehouses) do
      add :name, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :region, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:inventory_warehouses, [:name])

    create table(:inventory_suppliers) do
      add :name, :string, null: false
      add :contact_name, :string, null: false
      add :email, :string, null: false
      add :rating, :decimal
      timestamps(type: :utc_datetime)
    end

    create unique_index(:inventory_suppliers, [:email])

    create table(:inventory_stock_items) do
      add :sku, :string, null: false
      add :name, :string, null: false
      add :quantity, :integer, null: false
      add :reorder_level, :integer, null: false
      add :unit_cost, :decimal, null: false
      add :selling_price, :decimal, null: false
      add :last_restocked, :date
      add :warehouse_id, references(:inventory_warehouses, on_delete: :restrict), null: false
      add :supplier_id, references(:inventory_suppliers, on_delete: :restrict), null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:inventory_stock_items, [:sku])
    create index(:inventory_stock_items, [:warehouse_id])
    create index(:inventory_stock_items, [:supplier_id])
    create index(:inventory_stock_items, [:quantity])

    # Demo 8: Leads with transformers (15K rows)
    create table(:lead_sources) do
      add :name, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:lead_sources, [:name])

    create table(:lead_stages) do
      add :name, :string, null: false
      add :position, :integer, null: false
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:lead_stages, [:name])

    create table(:sales_reps) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :territory, :string, null: false
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:sales_reps, [:email])

    create table(:leads) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone, :string
      add :company_name, :string, null: false
      add :deal_value, :decimal, null: false
      add :is_hot, :boolean, default: false
      add :last_contacted_at, :utc_datetime
      add :notes, :text
      add :source_id, references(:lead_sources, on_delete: :restrict), null: false
      add :stage_id, references(:lead_stages, on_delete: :restrict), null: false
      add :sales_rep_id, references(:sales_reps, on_delete: :restrict), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:leads, [:source_id])
    create index(:leads, [:stage_id])
    create index(:leads, [:sales_rep_id])
    create index(:leads, [:deal_value])
    create index(:leads, [:is_hot])
    create index(:leads, [:last_contacted_at])

    # Demo 9: Projects with card mode (5K rows)
    create table(:clients) do
      add :name, :string, null: false
      add :industry, :string, null: false
      add :city, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create table(:project_types) do
      add :name, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:project_types, [:name])

    create table(:projects) do
      add :name, :string, null: false
      add :description, :text
      add :status, :string, null: false
      add :budget, :decimal, null: false
      add :spent, :decimal
      add :start_date, :date, null: false
      add :end_date, :date
      add :progress, :integer, null: false
      add :team_size, :integer, null: false
      add :is_featured, :boolean, default: false
      add :client_id, references(:clients, on_delete: :restrict), null: false
      add :project_type_id, references(:project_types, on_delete: :restrict), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:projects, [:client_id])
    create index(:projects, [:project_type_id])
    create index(:projects, [:status])
    create index(:projects, [:budget])
    create index(:projects, [:progress])

    # Demo 10: Flagship 1M products
    create table(:flagship_brands) do
      add :name, :string, null: false
      add :country, :string, null: false
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:flagship_brands, [:name])

    create table(:flagship_categories) do
      add :name, :string, null: false
      add :slug, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:flagship_categories, [:slug])

    create table(:flagship_warehouses) do
      add :name, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :region, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:flagship_warehouses, [:name])

    create table(:flagship_products) do
      add :sku, :string, null: false
      add :name, :string, null: false
      add :description, :text
      add :price, :decimal, null: false
      add :cost, :decimal, null: false
      add :stock_quantity, :integer, null: false
      add :status, :string, null: false
      add :is_featured, :boolean, default: false
      add :rating, :decimal
      add :brand_id, references(:flagship_brands, on_delete: :restrict), null: false
      add :category_id, references(:flagship_categories, on_delete: :restrict), null: false
      add :warehouse_id, references(:flagship_warehouses, on_delete: :restrict), null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:flagship_products, [:sku])
    create index(:flagship_products, [:brand_id])
    create index(:flagship_products, [:category_id])
    create index(:flagship_products, [:warehouse_id])
    create index(:flagship_products, [:price])
    create index(:flagship_products, [:status])
    create index(:flagship_products, [:is_featured])
    create index(:flagship_products, [:rating])
    create index(:flagship_products, [:name])
    create index(:flagship_products, [:inserted_at])
  end
end
