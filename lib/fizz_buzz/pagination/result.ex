defmodule FizzBuzz.Pagination.Result do
  @moduledoc """
  Results struct to represent pagination calculation results
  """

  defstruct [:current_page, :total_pages, :first_index, :page_size]
end
