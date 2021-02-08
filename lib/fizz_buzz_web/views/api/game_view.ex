defmodule FizzBuzzWeb.Api.GameView do
  def render("index.json", %{fizz_buzzes: fizz_buzzes}) do
    %{
      fizz_buzzes: Enum.map(fizz_buzzes, fn fizz_buzz -> fizz_buzz_json(fizz_buzz) end)
    }
  end

  defp fizz_buzz_json(fizz_buzz) do
    %{
      number: fizz_buzz.number,
      result: fizz_buzz.string
    }
  end
end
