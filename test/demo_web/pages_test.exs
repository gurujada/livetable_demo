defmodule DemoWeb.PagesTest do
  use DemoWeb.ConnCase

  for path <- ~w(/ /contacts /orders /inventory /leads /projects /store /live /flagship) do
    test "GET #{path} renders", %{conn: conn} do
      assert html_response(get(conn, unquote(path)), 200) =~ "LiveTable"
    end
  end

  test "merged demos redirect to the demo that shows their features", %{conn: conn} do
    assert redirected_to(get(conn, "/tasks")) == "/orders"
    assert redirected_to(get(conn, "/invoices")) == "/inventory"
  end
end
