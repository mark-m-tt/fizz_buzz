defmodule FizzBuzz.Accounts.User do
  @moduledoc """
  The User module - used for signing in and saving favourites.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :encrypted_password, :string
    field :username, :string
    has_many :favourites, FizzBuzz.Accounts.Favourite

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :encrypted_password])
    |> unique_constraint(:username)
    |> validate_required([:username, :encrypted_password])
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
