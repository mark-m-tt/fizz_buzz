defmodule FizzBuzz.Pagination.Calculator do
  @moduledoc """
  Heart of the Pagination context. This module is responsible
  For taking the requested page details and returning a Pagination.Result
  struct.
  """

  def perform(item_count: item_count, page_size: page_size, page_number: page_number) do
    if index_out_of_range?(item_count, page_size, page_number) do
      {:error, "The requested page has no results"}
    else
      {:ok, results(item_count, page_size, page_number)}
    end
  end

  def default_calculator, do: perform(item_count: 100_000_000_000, page_size: 100, page_number: 1)

  defp first_index(_page_size, 1), do: 0

  defp first_index(page_size, page_number) do
    page_size * (page_number - 1)
  end

  defp index_out_of_range?(item_count, page_size, page_number) do
    index = first_index(page_size, page_number)
    index < 0 or index > item_count - 1
  end

  defp page_count(item_count, page_size) when rem(item_count, page_size) == 0,
    do: div(item_count, page_size)

  defp page_count(item_count, page_size), do: div(item_count, page_size) + 1

  defp results(item_count, page_size, page_number) do
    %FizzBuzz.Pagination.Result{
      page_number: page_number,
      first_index: first_index(page_size, page_number),
      total_pages: page_count(item_count, page_size),
      page_size: page_size
    }
  end
end
