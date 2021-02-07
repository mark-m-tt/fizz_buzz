defmodule FizzBuzzWeb.Helpers.ViewHelpers do
  @moduledoc """
  Helper methods for views
  """

  def number_is_favourited?(number, favourites) do
    Enum.any?(favourites, fn %FizzBuzz.Accounts.Favourite{number: fave_number} ->
      number == fave_number
    end)
  end

  def favourite_for_number(number, favourites) do
    Enum.find(favourites, fn %FizzBuzz.Accounts.Favourite{number: fave_number} ->
      number == fave_number
    end)
  end
end
