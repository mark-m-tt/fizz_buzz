defmodule FizzBuzz.Repo.Migrations.CreateFavourites do
  use Ecto.Migration

  def change do
    create table(:favourites) do
      add :number, :integer
      add :user_id, references("users")
      timestamps()
    end

    create unique_index(:favourites, [:number, :user_id])
  end
end
