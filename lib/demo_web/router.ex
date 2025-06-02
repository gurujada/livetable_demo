defmodule DemoWeb.Router do
  use DemoWeb, :router
 import Oban.Web.Router
 
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DemoWeb do
    pipe_through :browser

    oban_dashboard("/oban")
    get "/", PageController, :home
    live "/posts", PostLive.Index, :index
    live "/products", ProductLive.Index, :index
    live "/employees", BasicTableLive
    live "/boolean", Filters.BooleanLive
    live "/range", Filters.RangeLive
    live "/datetimerange", Filters.DateRangeLive
    live "/select", Filters.SelectLive
    live "/search", SearchLive
    live "/joins", JoinLive
    live "/joinslive", JoinsLive
    live "/custombadge", CustomBadgeLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", DemoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:demo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DemoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
