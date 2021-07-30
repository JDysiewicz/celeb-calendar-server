defmodule CelebServerWeb.Router do
  use CelebServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_auth
  end

  pipeline :api_admin do
    plug :ensure_admin
  end

  scope "/api", CelebServerWeb do
    pipe_through :api
    post "/users/sign_in", UserController, :sign_in
    post "/users", UserController, :create
  end

  scope "/api", CelebServerWeb do
    pipe_through [:api, :api_auth]
    resources "/users", UserController, except: [:new, :edit, :create, :index]
    post "/users/sign_out", UserController, :sign_out
  end

  scope "/api", CelebServerWeb do
    pipe_through [:api]
    get "/celebs", CelebController, :index
    get "/celebs/:id", CelebController, :show
  end

  scope "/api", CelebServerWeb do
    pipe_through [:api, :api_auth, :api_admin]
    get "/users", UserController, :index
    post "/celebs", CelebController, :create
    patch "/celebs/:id", CelebController, :update
    put "/celebs/:id", CelebController, :update
    delete "/celebs/:id", CelebController, :delete
  end

  defp ensure_auth(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(CelebServerWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
    end
  end

  defp ensure_admin(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if CelebServer.Account.is_admin?(current_user_id) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> put_view(CelebServerWeb.ErrorView)
      |> render("403.json", message: "Insufficient Permissions")
      |> halt()
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: CelebServerWeb.Telemetry
    end
  end
end
