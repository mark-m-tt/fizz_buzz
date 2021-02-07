defmodule FizzBuzz.Pagination.Result do
  @moduledoc """
  Results struct to represent pagination calculation results
  """

  defstruct [:page_number, :total_pages, :first_index, :page_size]
end
