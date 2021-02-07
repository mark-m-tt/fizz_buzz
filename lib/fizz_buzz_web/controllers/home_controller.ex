defmodule FizzBuzzWeb.HomeController do
  use FizzBuzzWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
