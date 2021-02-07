defmodule FizzBuzz.FizzBuzz do
  @moduledoc """
  Creates a map of maps, with each submap containing an integer and a string,
  as per the rules of Fizz Buzz: https://en.wikipedia.org/wiki/Fizz_buzz
  """

  defstruct [:number, :string]

  def perform(starting_number: index, count: count) do
    index..(index + count - 1)
    |> Enum.map(fn number -> %FizzBuzz.FizzBuzz{number: number, string: buzz(number)} end)
  end

  defp buzz(number) when rem(number, 15) == 0, do: "fizzbuzz"
  defp buzz(number) when rem(number, 5) == 0, do: "buzz"
  defp buzz(number) when rem(number, 3) == 0, do: "fizz"
  defp buzz(number), do: Integer.to_string(number)
end
