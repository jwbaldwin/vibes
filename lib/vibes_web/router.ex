defmodule VibesWeb.Router do
  use VibesWeb, :router

  def assign_client_id(conn, _opts) do
    case get_session(conn, :session_id) do
      nil -> put_session(conn, :session_id, Ecto.UUID.generate())
      _client_id -> conn
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VibesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :assign_client_id
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VibesWeb do
    get "/healthz", HealthController, :show
  end

  scope "/", VibesWeb do
    pipe_through :browser

    live "/", RoomLive, :index
    get "/feedback", FeedbackController, :index
  end

  pipeline :management do
    plug :put_root_layout, html: {VibesWeb.Layouts, :management}
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug VibesWeb.AdminAuth
  end

  scope "/", VibesWeb do
    pipe_through [:browser, :management]
    get "/admin/login", AdminSessionController, :new
    post "/admin/login", AdminSessionController, :create
    delete "/admin/logout", AdminSessionController, :delete
  end

  scope "/", VibesWeb do
    pipe_through [:browser, :management, :admin]

    live_session :admin, on_mount: [{VibesWeb.AdminAuth, :admin}] do
      live "/admin", AdminLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", VibesWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:vibes, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VibesWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # Last, so every fixed path above wins over a station name.
  scope "/", VibesWeb do
    pipe_through :browser

    live "/:station", RoomLive, :index
  end
end
