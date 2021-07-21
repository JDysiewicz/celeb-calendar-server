defmodule CelebServerWeb.UserView do
  use CelebServerWeb, :view
  alias CelebServerWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username, perm: user.perm}
  end

  def render("sign_in.json", %{user: user}) do
    %{
      data: %{
        user: %{username: user.username, id: user.id, perm: user.perm}
      }
    }
  end
end
