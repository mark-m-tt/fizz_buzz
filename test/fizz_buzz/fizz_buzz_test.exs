defmodule FizzBuzz.FizzBuzzTest do
  use ExUnit.Case, async: true

  alias FizzBuzz.FizzBuzz

  describe "perform/1" do
    test "returns fizz for the number 3" do
      assert perform(starting_number: 3, count: 1) == [%FizzBuzz{number: 3, string: "fizz"}]
    end

    test "returns buzz for the number 5" do
      assert perform(starting_number: 5, count: 1) == [%FizzBuzz{number: 5, string: "buzz"}]
    end

    test "returns fizzbuzz for the number 15" do
      assert perform(starting_number: 15, count: 1) == [%FizzBuzz{number: 15, string: "fizzbuzz"}]
    end

    test "returns the integer as a string for all other numbers" do
      expected_results =
        results_array()
        |> Enum.map(fn [number, string] ->
          %FizzBuzz{number: number, string: string}
        end)

      assert perform(starting_number: 1, count: 30) == expected_results
    end
  end

  defp perform(starting_number: starting_number, count: count) do
    FizzBuzz.perform(starting_number: starting_number, count: count)
  end

  defp results_array do
    [
      [1, "1"],
      [2, "2"],
      [3, "fizz"],
      [4, "4"],
      [5, "buzz"],
      [6, "fizz"],
      [7, "7"],
      [8, "8"],
      [9, "fizz"],
      [10, "buzz"],
      [11, "11"],
      [12, "fizz"],
      [13, "13"],
      [14, "14"],
      [15, "fizzbuzz"],
      [16, "16"],
      [17, "17"],
      [18, "fizz"],
      [19, "19"],
      [20, "buzz"],
      [21, "fizz"],
      [22, "22"],
      [23, "23"],
      [24, "fizz"],
      [25, "buzz"],
      [26, "26"],
      [27, "fizz"],
      [28, "28"],
      [29, "29"],
      [30, "fizzbuzz"]
    ]
  end
end
