defmodule Demo.Store.Product do
  @moduledoc "A product in the storefront demo."
  use Ecto.Schema

  schema "store_products" do
    field :name, :string
    field :category, :string
    field :image, :string
    field :price, :decimal
    field :rating, :decimal
    field :reviews, :integer
    field :in_stock, :boolean
    field :is_new, :boolean

    timestamps(type: :utc_datetime)
  end

  # Each item is a photo in priv/static/images/store, what it is, and its price range in rupees.
  @categories [
    {"Audio", "lucide-headphones",
     [
       {"headphones-silver", "Studio Headphones", 2_999..9_999},
       {"headphones-black", "Over-ear Headphones", 3_499..14_999},
       {"earbuds", "Wireless Earbuds", 1_499..8_999},
       {"speaker", "Portable Speaker", 1_999..7_999}
     ]},
    {"Cameras", "lucide-camera",
     [
       {"camera", "DSLR Camera", 34_999..74_999},
       {"camera-lenses", "Mirrorless Kit", 49_999..1_19_999},
       {"instant-camera", "Instant Camera", 5_999..12_999}
     ]},
    {"Kitchen", "lucide-coffee",
     [
       {"coffee-cups", "Ceramic Cups, set of 2", 799..1_999},
       {"coffee-set", "Pour-over Coffee Set", 2_499..6_999},
       {"kitchen", "Cookware Set", 3_999..11_999}
     ]},
    {"Desk", "lucide-lamp-desk",
     [
       {"desk-lamp", "Desk Lamp", 1_299..4_999},
       {"keyboard", "Wireless Keyboard", 1_999..6_999},
       {"laptop", "Ultrabook 14", 54_999..1_29_999},
       {"phone", "Smartphone", 14_999..79_999}
     ]},
    {"Outdoors", "lucide-tent",
     [
       {"tent", "Two-person Tent", 4_999..14_999},
       {"backpack", "Daypack, 22 L", 1_499..4_999},
       {"sneaker", "Trail Running Shoes", 2_999..9_999}
     ]},
    {"Wearables", "lucide-watch",
     [
       {"watch-white", "Minimal Watch", 2_499..8_999},
       {"smartwatch-black", "Smartwatch", 9_999..39_999},
       {"smartwatch-blue", "Fitness Watch", 4_999..19_999},
       {"sunglasses", "Polarised Sunglasses", 999..5_999},
       {"watch-leather", "Chronograph Watch", 6_999..24_999}
     ]}
  ]

  def categories, do: Enum.map(@categories, &elem(&1, 0))

  def icon(category),
    do: Enum.find_value(@categories, "lucide-package", fn {c, i, _} -> c == category && i end)

  def items(category),
    do: Enum.find_value(@categories, fn {c, _, items} -> c == category && items end)
end
