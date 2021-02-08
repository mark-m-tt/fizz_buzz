defmodule FizzBuzz.Accounts.User do
  @moduledoc """
  The User module - used for signing in and saving favourites.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :password, :string
    field :password_confirmation, :string
    field :username, :string
    has_many :favourites, FizzBuzz.Accounts.Favourite

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_required(:password_confirmation)
    |> unique_constraint(:username)
    |> validate_confirmation(:password, message: "does not match password!")
    |> update_change(:password, &Bcrypt.hashpwsalt/1)
  end
end
