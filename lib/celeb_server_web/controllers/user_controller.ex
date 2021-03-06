defmodule CelebServerWeb.UserController do
  use CelebServerWeb, :controller

  alias CelebServer.Account
  alias CelebServer.Account.User
  alias CelebServer.Celebs

  action_fallback CelebServerWeb.FallbackController

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  # matches for a user account created which also has celeb info; creates celeb account and user account at same time
  def create(conn, %{"user" => user_params, "celeb" => celeb_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      celeb_with_id = Map.put(celeb_params, "user_id", user.id)

      case Celebs.create_celeb(celeb_with_id) do
        {:ok, %Celebs.Celeb{}} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_path(conn, :show, user))
          |> render("show.json", user: user)

        something ->
          IO.inspect(something)
          Account.delete_user(user)
      end
    end
  end

  def create(conn, %{"user" => user_params}) do
    case Account.create_user(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", user: user)

      {:error,
       %Ecto.Changeset{errors: [username: {_, [constraint: :unique, constraint_name: _]}]}} ->
        IO.puts("Error: username <#{Map.get(user_params, "username")}> already in use.")

        conn
        |> put_status(:bad_request)
        |> put_view(CelebServerWeb.ErrorView)
        |> render("400.json", message: "Username already in use")
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    case CelebServer.Account.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> put_status(:ok)
        |> put_view(CelebServerWeb.UserView)
        |> render("sign_in.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user_id)
        |> put_status(:unauthorized)
        |> put_view(CelebServerWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  def sign_out(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_view(CelebServerWeb.UserView)
    |> render("sign_out.json", %{})
  end

  def current_user(conn, _params) do
    current_user_id = get_session(conn, :current_user_id)
    user = CelebServer.Account.get_user!(current_user_id)

    conn
    |> put_status(:ok)
    |> put_view(CelebServerWeb.UserView)
    |> render("sign_in.json", user: user)
  end
end
