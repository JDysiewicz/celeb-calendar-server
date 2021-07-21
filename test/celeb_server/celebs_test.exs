defmodule CelebServer.CelebsTest do
  use CelebServer.DataCase

  alias CelebServer.Celebs

  describe "celebs" do
    alias CelebServer.Celebs.Celeb

    @valid_attrs %{birthday: ~D[2010-04-17], description: "some description", followers: 42, image: "some image", is_private: true, name: "some name"}
    @update_attrs %{birthday: ~D[2011-05-18], description: "some updated description", followers: 43, image: "some updated image", is_private: false, name: "some updated name"}
    @invalid_attrs %{birthday: nil, description: nil, followers: nil, image: nil, is_private: nil, name: nil}

    def celeb_fixture(attrs \\ %{}) do
      {:ok, celeb} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Celebs.create_celeb()

      celeb
    end

    test "list_celebs/0 returns all celebs" do
      celeb = celeb_fixture()
      assert Celebs.list_celebs() == [celeb]
    end

    test "get_celeb!/1 returns the celeb with given id" do
      celeb = celeb_fixture()
      assert Celebs.get_celeb!(celeb.id) == celeb
    end

    test "create_celeb/1 with valid data creates a celeb" do
      assert {:ok, %Celeb{} = celeb} = Celebs.create_celeb(@valid_attrs)
      assert celeb.birthday == ~D[2010-04-17]
      assert celeb.description == "some description"
      assert celeb.followers == 42
      assert celeb.image == "some image"
      assert celeb.is_private == true
      assert celeb.name == "some name"
    end

    test "create_celeb/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Celebs.create_celeb(@invalid_attrs)
    end

    test "update_celeb/2 with valid data updates the celeb" do
      celeb = celeb_fixture()
      assert {:ok, %Celeb{} = celeb} = Celebs.update_celeb(celeb, @update_attrs)
      assert celeb.birthday == ~D[2011-05-18]
      assert celeb.description == "some updated description"
      assert celeb.followers == 43
      assert celeb.image == "some updated image"
      assert celeb.is_private == false
      assert celeb.name == "some updated name"
    end

    test "update_celeb/2 with invalid data returns error changeset" do
      celeb = celeb_fixture()
      assert {:error, %Ecto.Changeset{}} = Celebs.update_celeb(celeb, @invalid_attrs)
      assert celeb == Celebs.get_celeb!(celeb.id)
    end

    test "delete_celeb/1 deletes the celeb" do
      celeb = celeb_fixture()
      assert {:ok, %Celeb{}} = Celebs.delete_celeb(celeb)
      assert_raise Ecto.NoResultsError, fn -> Celebs.get_celeb!(celeb.id) end
    end

    test "change_celeb/1 returns a celeb changeset" do
      celeb = celeb_fixture()
      assert %Ecto.Changeset{} = Celebs.change_celeb(celeb)
    end
  end
end
