defmodule CelebServer.Celebs.Celeb do
  use Ecto.Schema
  import Ecto.Changeset

  schema "celebs" do
    field :birthday, :date
    field :description, :string
    field :followers, :integer
    field :image, :string, default: nil
    field :is_private, :boolean, default: false
    field :name, :string
    field :manager, :integer, default: nil
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(celeb, attrs) do
    celeb
    |> cast(attrs, [
      :name,
      :birthday,
      :followers,
      :description,
      :image,
      :is_private,
      :manager,
      :user_id
    ])
    |> validate_required([:name, :birthday, :followers, :description, :is_private, :user_id])
  end
end
