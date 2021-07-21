defmodule CelebServer.Celebs do
  @moduledoc """
  The Celebs context.
  """

  import Ecto.Query, warn: false
  alias CelebServer.Repo

  alias CelebServer.Celebs.Celeb

  @doc """
  Returns the list of celebs.

  ## Examples

      iex> list_celebs()
      [%Celeb{}, ...]

  """
  def list_celebs do
    Repo.all(Celeb)
  end

  @doc """
  Gets a single celeb.

  Raises `Ecto.NoResultsError` if the Celeb does not exist.

  ## Examples

      iex> get_celeb!(123)
      %Celeb{}

      iex> get_celeb!(456)
      ** (Ecto.NoResultsError)

  """
  def get_celeb!(id), do: Repo.get!(Celeb, id)

  @doc """
  Creates a celeb.

  ## Examples

      iex> create_celeb(%{field: value})
      {:ok, %Celeb{}}

      iex> create_celeb(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_celeb(attrs \\ %{}) do
    changeset = Celeb.changeset(%Celeb{}, attrs)

    if changeset.valid? do
      Repo.insert(changeset)
    else
      IO.inspect(changeset.errors)
      {:error, changeset.errors}
    end
  end

  @doc """
  Updates a celeb.

  ## Examples

      iex> update_celeb(celeb, %{field: new_value})
      {:ok, %Celeb{}}

      iex> update_celeb(celeb, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_celeb(%Celeb{} = celeb, attrs) do
    celeb
    |> Celeb.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a celeb.

  ## Examples

      iex> delete_celeb(celeb)
      {:ok, %Celeb{}}

      iex> delete_celeb(celeb)
      {:error, %Ecto.Changeset{}}

  """
  def delete_celeb(%Celeb{} = celeb) do
    Repo.delete(celeb)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking celeb changes.

  ## Examples

      iex> change_celeb(celeb)
      %Ecto.Changeset{data: %Celeb{}}

  """
  def change_celeb(%Celeb{} = celeb, attrs \\ %{}) do
    Celeb.changeset(celeb, attrs)
  end
end
