defmodule FizzBuzz.Factory do
  @moduledoc """
  List of factories for use in tests
  """
  use ExMachina.Ecto, repo: FizzBuzz.Repo

  def user_factory do
    %FizzBuzz.Accounts.User{
      username: ExMachina.sequence("some username"),
      password: "Some password",
      password_confirmation: "Some password"
    }
  end

  def favourite_factory do
    %FizzBuzz.Accounts.Favourite{
      number: 1,
      user: build(:user)
    }
  end
end
