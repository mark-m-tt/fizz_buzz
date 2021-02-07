defmodule FizzBuzzWeb.Helpers.ControllerHelpers do
  @moduledoc """
  Helper methods for controllers
  """

  alias FizzBuzz.Pagination.Calculator

  def default_fizz_buzz_list do
    {:ok, list} = FizzBuzz.FizzBuzz.default_list()
    list
  end

  def default_calculator do
    {:ok, calculator} = Calculator.default_calculator()
    calculator
  end
end
