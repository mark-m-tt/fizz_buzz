defmodule FizzBuzz.Pagination.CalculatorTest do
  use ExUnit.Case

  alias FizzBuzz.Pagination.{Calculator, Result}

  describe "perform/1" do
    test "it returns correct values whith an item_count, page_size and page_number of 1" do
      valid_result = result(item_count: 1, page_size: 1, page_number: 1)

      assert valid_result ==
               {:ok,
                %Result{
                  page_number: 1,
                  total_pages: 1,
                  first_index: 0,
                  page_size: 1
                }}
    end

    test "it returns correct values when requesting the first page" do
      valid_result = result(item_count: max_page_size(), page_size: 100, page_number: 1)

      assert valid_result ==
               {:ok,
                %Result{
                  page_number: 1,
                  total_pages: 1_000_000_000,
                  first_index: 0,
                  page_size: 100
                }}
    end

    test "it returns correct values when requesting the second page" do
      valid_result = result(item_count: max_page_size(), page_size: 100, page_number: 2)

      assert valid_result ==
               {:ok,
                %Result{
                  page_number: 2,
                  total_pages: 1_000_000_000,
                  first_index: 100,
                  page_size: 100
                }}
    end

    test "it returns correct values when requesting page number 1000" do
      valid_result = result(item_count: max_page_size(), page_size: 100, page_number: 1_000)

      assert valid_result ==
               {:ok,
                %Result{
                  page_number: 1_000,
                  total_pages: 1_000_000_000,
                  first_index: 99_900,
                  page_size: 100
                }}
    end

    test "it returns an error struct when the requested index is outside of the item_count" do
      invalid_result = result(item_count: 10, page_size: 10, page_number: 2)
      assert invalid_result == no_results_tuple()
    end

    test "it returns an error struct when given a minus page_number " do
      invalid_result = result(item_count: 10, page_size: 10, page_number: -1)
      assert invalid_result == no_results_tuple()
    end

    test "it returns an error when the item count is 0" do
      invalid_result = result(item_count: 0, page_size: 10, page_number: 1)
      assert invalid_result == no_results_tuple()
    end

    test "it returns an error when the page_number is 0" do
      invalid_result = result(item_count: 10, page_size: 10, page_number: 0)
      assert invalid_result == no_results_tuple()
    end
  end

  defp result(item_count: item_count, page_size: page_size, page_number: page_number) do
    Calculator.perform(item_count: item_count, page_size: page_size, page_number: page_number)
  end

  def no_results_tuple, do: {:error, "The requested page has no results"}

  defp max_page_size, do: Application.get_env(:fizz_buzz, :max_size)
end
