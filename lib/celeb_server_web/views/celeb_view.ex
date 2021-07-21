defmodule CelebServerWeb.CelebView do
  use CelebServerWeb, :view
  alias CelebServerWeb.CelebView

  def render("index.json", %{celebs: celebs}) do
    %{data: render_many(celebs, CelebView, "celeb.json")}
  end

  def render("show.json", %{celeb: celeb}) do
    %{data: render_one(celeb, CelebView, "celeb.json")}
  end

  def render("celeb.json", %{celeb: celeb}) do
    %{
      id: celeb.id,
      name: celeb.name,
      birthday: celeb.birthday,
      followers: celeb.followers,
      description: celeb.description,
      image: celeb.image,
      is_private: celeb.is_private,
      user_id: celeb.user_id,
      manager: celeb.manager
    }
  end
end
