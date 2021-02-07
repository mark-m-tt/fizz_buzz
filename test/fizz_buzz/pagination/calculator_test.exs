defmodule FizzBuzz.Pagination.CalculatorTest do
  use ExUnit.Case

  alias FizzBuzz.Pagination.{Calculator, Result}

  describe "perform/1" do
    test "it returns correct values when requesting the first page" do
      valid_result =
        Calculator.perform(%Calculator{item_count: 10, page_size: 1, current_page: 1})

      assert valid_result == %Result{
               current_page: 1,
               total_pages: 10,
               first_index: 0,
               page_size: 1
             }
    end
  end
end
