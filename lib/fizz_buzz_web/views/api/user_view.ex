defmodule FizzBuzzWeb.Api.UserView do
  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
