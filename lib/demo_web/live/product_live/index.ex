defmodule DemoWeb.ProductLive.Index do
  use DemoWeb, :live_view

  use LiveTable.LiveResource

  def mount(_params, _session, socket) do
    socket = socket |> assign(:data_provider, {Demo.Catalog, :list_products, []})
    {:ok, assign(socket, page_title: "Products")}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    Demo.Catalog.delete_product(id)
    {:noreply, socket}
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
        computed: dynamic([p], fragment("? * ?", p.price, p.stock_quantity))
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
            condition: dynamic([_, _, _, s], s.name == "Mahindra Supplies")
          }
        ),
      prices:
        Range.new(:price, "10-to-100", %{label: "Enter range", min: 0, max: 500, unit: "$"}),
      supplier_name:
        Select.new({:suppliers, :name}, "supplier_name", %{
          label: "Supplier",
          placeholder: "Search for suppliers...",
          options_source: {Demo.Catalog, :search_suppliers, []}
        })
    ]
  end

  # def actions do
  #   [
  #     edit: &edit_action/1,
  #     delete: &delete_action/1
  #   ]
  # end

  defp edit_action(assigns) do
    ~H"""
    <.link navigate={~p"/products/#{@record.id}/edit"} class="text-blue-600 mr-4 my-1 px-2 py-1 rounded-md bg-blue-500 hover:bg-blue-600 text-white hover:cursor-pointer">
      Edit
    </.link>
    """
  end

  defp delete_action(assigns) do
    ~H"""
    <button
      phx-click="delete"
      phx-value-id={@record.id}
      data-confirm="Are you sure?"
      class="text-red-600 mr-4 my-1 px-2 py-1 rounded-md bg-red-500 hover:bg-red-600 text-white hover:cursor-pointer"
    >
      Delete
    </button>
    """
  end


  def table_options() do
    %{exports: %{enabled: true}, debug: :query}
  end
end
