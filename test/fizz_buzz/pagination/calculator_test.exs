defmodule FizzBuzz.Pagination.CalculatorTest do
  use ExUnit.Case

  alias FizzBuzz.Pagination.{Calculator, Result}

  describe "perform/1" do
    test "it returns correct values whith an item_count, page_size and current_page of 1" do
      valid_result = result(item_count: 1, page_size: 1, current_page: 1)

      assert valid_result ==
               {:ok,
                %Result{
                  current_page: 1,
                  total_pages: 1,
                  first_index: 0,
                  page_size: 1
                }}
    end

    test "it returns correct values when requesting the first page" do
      valid_result = result(item_count: 100_000_000_000, page_size: 100, current_page: 1)

      assert valid_result ==
               {:ok,
                %Result{
                  current_page: 1,
                  total_pages: 1_000_000_000,
                  first_index: 0,
                  page_size: 100
                }}
    end

    test "it returns correct values when requesting the second page" do
      valid_result = result(item_count: 100_000_000_000, page_size: 100, current_page: 2)

      assert valid_result ==
               {:ok,
                %Result{
                  current_page: 2,
                  total_pages: 1_000_000_000,
                  first_index: 100,
                  page_size: 100
                }}
    end

    test "it returns correct values when requesting page number 1000" do
      valid_result = result(item_count: 100_000_000_000, page_size: 100, current_page: 1_000)

      assert valid_result ==
               {:ok,
                %Result{
                  current_page: 1_000,
                  total_pages: 1_000_000_000,
                  first_index: 99_900,
                  page_size: 100
                }}
    end

    test "it returns an error struct when the requested index is outside of the item_count" do
      invalid_result = result(item_count: 10, page_size: 10, current_page: 2)
      assert invalid_result == no_results_tuple()
    end

    test "it returns an error struct when given a minus current_page " do
      invalid_result = result(item_count: 10, page_size: 10, current_page: -1)
      assert invalid_result == no_results_tuple()
    end

    test "it returns an error when the item count is 0" do
      invalid_result = result(item_count: 0, page_size: 10, current_page: 1)
      assert invalid_result == no_results_tuple()
    end

    test "it returns an error when the current_page is 0" do
      invalid_result = result(item_count: 10, page_size: 10, current_page: 0)
      assert invalid_result == no_results_tuple()
    end
  end

  defp result(item_count: item_count, page_size: page_size, current_page: current_page) do
    Calculator.perform(item_count: item_count, page_size: page_size, current_page: current_page)
  end

  def no_results_tuple, do: {:error, "The requested page has no results"}
end
