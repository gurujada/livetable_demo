defmodule DemoWeb.ProductLive.Index do
  use DemoWeb, :live_view

  use LiveTable.LiveResource

  def mount(_params, _session, socket) do
    socket = socket |> assign(:data_provider, {Demo.Catalog, :list_products, []})
    {:ok, assign(socket, page_title: "Products")}
  end

  def fields() do
    [
      id: %{
        label: "ID",
        sortable: true,
        searchable: false
      },
      name: %{
        label: "Product Name",
        sortable: true,
        searchable: true
      },
      description: %{
        label: "Description",
        sortable: true,
        searchable: false
      },
      price: %{
        label: "Price",
        sortable: true,
        searchable: false
      },
      supplier_name: %{
        label: "Supplier Name",
        searchable: false,
        sortable: false
      },
      supplier_contact: %{
        label: "Supplier Contact",
        assoc: {:suppliers, :contact_info},
        searchable: false,
        sortable: true
      },
      category_name: %{
        label: "Category Name",
        
        searchable: false,
        sortable: false
      },
      category_description: %{
        label: "Category Description",
        assoc: {:category, :description},
        searchable: false,
        sortable: true
      },
      image: %{
        label: "Image",
        sortable: false,
        searchable: false,
        assoc: {:image, :url}
      },
      amount: %{
        label: "Amount",
        sortable: true,
        searchable: false,
        computed: dynamic([resource: r], fragment("? * ?", r.price, r.stock_quantity))
      }
    ]
  end

  def filters() do
    [
      price:
        Boolean.new(
          :price,
          "under-100",
          %{label: "Less than 100", condition: dynamic([p], p.price < 100)}
        ),
      cost_filter:
        Boolean.new(
          :supplier_email,
          "supplier",
          %{
            label: "Mahindra",
            condition: dynamic([p, s], s.name == "Mahindra Supplies")
          }
        ),
      prices:
        Range.new(:price, "10-to-100", %{label: "Enter range", min: 0, max: 500, unit: "$"}),
      # supplier_name:
      #   Select.new({:suppliers, :name}, "supplier_name", %{
      #     label: "Supplier",
      #     placeholder: "Search for suppliers...",
      #     options_source: {Demo.Catalog, :search_suppliers, []}
      #     # options: [{"Auto Parts Direct", ["id"]}],
      #     # option_template: &custom_template/1,
      #   })
    ]
  end

  def table_options() do
    %{exports: %{enabled: true}}
  end
end
