defmodule Demo.Catalog.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :url, :string
    belongs_to :product, Demo.Catalog.Product

    timestamps(type: :utc_datetime)
  end

  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url, :product_id])
    |> validate_required([:url, :product_id])
  end
end
