defmodule FizzBuzz.Accounts.Favourite do
  @moduledoc """
  Module and table for storing user's favourite numbers
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "favourites" do
    field :number, :integer
    belongs_to(:user, FizzBuzz.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(favourite, attrs) do
    favourite
    |> cast(attrs, [:number, :user_id])
    |> validate_required([:number, :user_id])
    |> validate_inclusion(:number, 1..max_page_size())
    |> unique_constraint(:number_user_id)
  end

  defp max_page_size, do: Application.get_env(:fizz_buzz, :max_size)
end
