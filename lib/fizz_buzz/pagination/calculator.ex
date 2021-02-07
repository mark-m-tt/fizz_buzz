defmodule FizzBuzz.Pagination.Calculator do
  @moduledoc """
  Heart of the Pagination context. This module is responsible
  For taking the requested page details and returning a Pagination.Result
  struct.
  """

  defstruct [:item_count, :page_size, :current_page]

  def perform(item_count: item_count, page_size: page_size, current_page: current_page) do
    if index_out_of_range?(item_count, page_size, current_page) do
      {:error, "The requested page has no results"}
    else
      {:ok, results(item_count, page_size, current_page)}
    end
  end

  defp first_index(page_size, current_page), do: page_size * (current_page - 1)

  defp index_out_of_range?(item_count, page_size, current_page) do
    index = first_index(page_size, current_page)
    index < 0 or index > item_count - 1
  end

  defp page_count(item_count, page_size) when rem(item_count, page_size) == 0,
    do: div(item_count, page_size)

  defp page_count(item_count, page_size), do: div(item_count, page_size) + 1

  defp results(item_count, page_size, current_page) do
    %FizzBuzz.Pagination.Result{
      current_page: current_page,
      first_index: first_index(page_size, current_page),
      total_pages: page_count(item_count, page_size),
      page_size: page_size
    }
  end
end
