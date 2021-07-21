defmodule CelebServerWeb.CelebController do
  use CelebServerWeb, :controller

  alias CelebServer.Celebs
  alias CelebServer.Celebs.Celeb

  action_fallback CelebServerWeb.FallbackController

  def index(conn, _params) do
    celebs = Celebs.list_celebs()
    render(conn, "index.json", celebs: celebs)
  end

  def create(conn, %{"celeb" => celeb_params}) do
    case Celebs.create_celeb(celeb_params) do
      {:ok, %Celeb{} = celeb} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.celeb_path(conn, :show, celeb))
        |> render("show.json", celeb: celeb)

      {:error, errors} ->
        IO.inspect(errors)

        conn
        |> put_status(:unauthorized)
        |> put_view(CelebServerWeb.ErrorView)
        |> render("401.json", message: "Invalid parameters")
    end
  end

  def show(conn, %{"id" => id}) do
    celeb = Celebs.get_celeb!(id)
    render(conn, "show.json", celeb: celeb)
  end

  def update(conn, %{"id" => id, "celeb" => celeb_params}) do
    celeb = Celebs.get_celeb!(id)

    with {:ok, %Celeb{} = celeb} <- Celebs.update_celeb(celeb, celeb_params) do
      render(conn, "show.json", celeb: celeb)
    end
  end

  def delete(conn, %{"id" => id}) do
    celeb = Celebs.get_celeb!(id)

    with {:ok, %Celeb{}} <- Celebs.delete_celeb(celeb) do
      send_resp(conn, :no_content, "")
    end
  end
end
