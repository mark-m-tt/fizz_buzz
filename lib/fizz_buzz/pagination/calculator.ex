defmodule FizzBuzz.Pagination.Calculator do
  @moduledoc """
  Heart of the Pagination context. This module is responsible
  For taking the requested page details and returning a Pagination.Result
  struct.
  """

  alias __MODULE__

  defstruct [:item_count, :page_size, :current_page]

  def perform(%Calculator{} = calculator) do
    %FizzBuzz.Pagination.Result{
      current_page: calculator.current_page,
      first_index: calculator.page_size * calculator.current_page - 1,
      total_pages: page_count(calculator.item_count, calculator.page_size),
      page_size: calculator.page_size
    }
  end

  defp page_count(item_count, page_size) do
    if rem(item_count, page_size) == 0 do
      item_count / page_size
    else
      item_count / page_size + 1
    end
  end
end
