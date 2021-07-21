defmodule CelebServer.Repo.Migrations.CreateCelebs do
  use Ecto.Migration

  def change do
    create table(:celebs) do
      add :name, :string, null: false
      add :birthday, :date, null: false
      add :followers, :integer, null: false
      add :description, :string, null: false
      add :image, :string
      add :is_private, :boolean, default: false, null: false
      add :manager, :id, null: true
      add :user_id, :id, null: false

      timestamps()
    end

  end
end
