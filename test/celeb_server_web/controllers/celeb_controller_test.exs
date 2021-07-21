defmodule CelebServerWeb.CelebControllerTest do
  use CelebServerWeb.ConnCase

  alias CelebServer.Celebs
  alias CelebServer.Celebs.Celeb

  @create_attrs %{
    birthday: ~D[2010-04-17],
    description: "some description",
    followers: 42,
    image: "some image",
    is_private: true,
    manager: 42,
    name: "some name"
  }
  @update_attrs %{
    birthday: ~D[2011-05-18],
    description: "some updated description",
    followers: 43,
    image: "some updated image",
    is_private: false,
    manager: 43,
    name: "some updated name"
  }
  @invalid_attrs %{birthday: nil, description: nil, followers: nil, image: nil, is_private: nil, manager: nil, name: nil}

  def fixture(:celeb) do
    {:ok, celeb} = Celebs.create_celeb(@create_attrs)
    celeb
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all celebs", %{conn: conn} do
      conn = get(conn, Routes.celeb_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create celeb" do
    test "renders celeb when data is valid", %{conn: conn} do
      conn = post(conn, Routes.celeb_path(conn, :create), celeb: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.celeb_path(conn, :show, id))

      assert %{
               "id" => id,
               "birthday" => "2010-04-17",
               "description" => "some description",
               "followers" => 42,
               "image" => "some image",
               "is_private" => true,
               "manager" => 42,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.celeb_path(conn, :create), celeb: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update celeb" do
    setup [:create_celeb]

    test "renders celeb when data is valid", %{conn: conn, celeb: %Celeb{id: id} = celeb} do
      conn = put(conn, Routes.celeb_path(conn, :update, celeb), celeb: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.celeb_path(conn, :show, id))

      assert %{
               "id" => id,
               "birthday" => "2011-05-18",
               "description" => "some updated description",
               "followers" => 43,
               "image" => "some updated image",
               "is_private" => false,
               "manager" => 43,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, celeb: celeb} do
      conn = put(conn, Routes.celeb_path(conn, :update, celeb), celeb: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete celeb" do
    setup [:create_celeb]

    test "deletes chosen celeb", %{conn: conn, celeb: celeb} do
      conn = delete(conn, Routes.celeb_path(conn, :delete, celeb))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.celeb_path(conn, :show, celeb))
      end
    end
  end

  defp create_celeb(_) do
    celeb = fixture(:celeb)
    %{celeb: celeb}
  end
end
