defmodule FizzBuzzWeb.Api.SessionView do
  # code omitted for brevity

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
