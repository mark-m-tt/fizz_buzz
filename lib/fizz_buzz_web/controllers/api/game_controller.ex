defmodule FizzBuzzWeb.Api.GameController do
  use FizzBuzzWeb, :controller

  def play(conn, params) do
    starting_number = params |> Map.get("starting_number", "1")
    count = params |> Map.get("count", "100")
    [starting_number, count] = [String.to_integer(starting_number), String.to_integer(count)]

    case FizzBuzz.FizzBuzz.perform(starting_number: starting_number, count: count) do
      {:ok, list} ->
        conn
        |> put_status(200)
        |> render("index.json", %{fizz_buzzes: list})

      {:error, error} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(FizzBuzzWeb.Api.ErrorView)
        |> render("raw_error.json", error: error)
    end
  end
end
