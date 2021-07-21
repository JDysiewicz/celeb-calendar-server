defmodule CelebServer.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password_hash, :string
    field :password, :string, virtual: true
    field :perm, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :perm])
    |> validate_required([:username, :password, :perm])
    |> unique_constraint(:username)
    |> hash_password()
    |> remove_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp hash_password(changeset), do: changeset

  # removes pass from changeset map so never displayed
  defp remove_password(changeset), do: change(changeset, %{password: ""})
end
