defmodule FizzBuzz.Factory do
  @moduledoc """
  List of factories for use in tests
  """
  use ExMachina.Ecto, repo: FizzBuzz.Repo

  def user_factory do
    %FizzBuzz.Accounts.User{
      username: "some username",
      encrypted_password: "Some encrypted password"
    }
  end
end
