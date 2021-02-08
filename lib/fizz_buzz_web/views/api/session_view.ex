defmodule FizzBuzzWeb.Api.SessionView do
  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
