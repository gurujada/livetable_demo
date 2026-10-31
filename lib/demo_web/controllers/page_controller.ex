defmodule DemoWeb.PageController do
  use DemoWeb, :controller

  # Demos that were merged into others keep working as links.
  @moved %{
    "tasks" => "/orders",
    "demo-employees" => "/orders",
    "products-simple" => "/orders",
    "invoices" => "/inventory"
  }

  def moved(conn, _params) do
    redirect(conn, to: Map.fetch!(@moved, hd(conn.path_info)))
  end
end
