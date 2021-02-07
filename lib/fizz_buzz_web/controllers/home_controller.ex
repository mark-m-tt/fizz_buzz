defmodule FizzBuzzWeb.HomeController do
  use FizzBuzzWeb, :controller

  import Ecto

  alias FizzBuzz.Accounts.User
  alias FizzBuzz.Pagination.Calculator
  alias FizzBuzz.Repo

  def index(conn, params) do
    page_size = params |> Map.get("page_size", "100")
    page_number = params |> Map.get("page_number", "1")

    [list, calculator] = fizz_buzz_list(page_size: int(page_size), page_number: int(page_number))

    render(conn, "index.html",
      list: list,
      calculator: calculator,
      favourites: favourite_numbers(conn)
    )
  end

  defp fizz_buzz_list(page_size: page_size, page_number: page_number) do
    case pagination_calculator(page_size: page_size, page_number: page_number) do
      {:ok, calculator} ->
        case FizzBuzz.FizzBuzz.perform(
               starting_number: calculator.first_index + 1,
               count: calculator.page_size
             ) do
          {:ok, list} -> [list, calculator]
          _ -> [[], default_calculator()]
        end

      _ ->
        [[], default_calculator()]
    end
  end

  defp pagination_calculator(page_size: page_size, page_number: page_number) do
    Calculator.perform(
      item_count: 100_000_000_000,
      page_size: page_size,
      page_number: page_number
    )
  end

  defp favourite_numbers(conn) do
    case current_user(conn) do
      %User{} = user -> Repo.all(assoc(user, :favourites))
      _ -> []
    end
  end

  defp int(string), do: String.to_integer(string)
end
