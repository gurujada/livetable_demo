defmodule Demo.Leads.Source do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lead_sources" do
    field :name, :string
    has_many :leads, Demo.Leads.Lead
    timestamps(type: :utc_datetime)
  end

  def changeset(source, attrs) do
    source
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

defmodule Demo.Leads.Stage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lead_stages" do
    field :name, :string
    field :position, :integer
    field :is_active, :boolean, default: true
    has_many :leads, Demo.Leads.Lead
    timestamps(type: :utc_datetime)
  end

  def changeset(stage, attrs) do
    stage
    |> cast(attrs, [:name, :position, :is_active])
    |> validate_required([:name, :position])
    |> unique_constraint(:name)
  end
end

defmodule Demo.Leads.SalesRep do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_reps" do
    field :name, :string
    field :email, :string
    field :territory, :string
    field :is_active, :boolean, default: true
    has_many :leads, Demo.Leads.Lead
    timestamps(type: :utc_datetime)
  end

  def changeset(sales_rep, attrs) do
    sales_rep
    |> cast(attrs, [:name, :email, :territory, :is_active])
    |> validate_required([:name, :email, :territory])
    |> unique_constraint(:email)
  end
end

defmodule Demo.Leads.Lead do
  @moduledoc """
  Schema for Demo 8: Transformers - Leads
  15,000 rows demonstrating query transformers.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "leads" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :company_name, :string
    field :deal_value, :decimal
    field :is_hot, :boolean, default: false
    field :last_contacted_at, :utc_datetime
    field :notes, :string

    belongs_to :source, Demo.Leads.Source
    belongs_to :stage, Demo.Leads.Stage
    belongs_to :sales_rep, Demo.Leads.SalesRep

    timestamps(type: :utc_datetime)
  end

  def changeset(lead, attrs) do
    lead
    |> cast(attrs, [
      :name,
      :email,
      :phone,
      :company_name,
      :deal_value,
      :is_hot,
      :last_contacted_at,
      :notes,
      :source_id,
      :stage_id,
      :sales_rep_id
    ])
    |> validate_required([
      :name,
      :email,
      :company_name,
      :deal_value,
      :source_id,
      :stage_id,
      :sales_rep_id
    ])
    |> foreign_key_constraint(:source_id)
    |> foreign_key_constraint(:stage_id)
    |> foreign_key_constraint(:sales_rep_id)
  end
end
