defmodule FizzBuzzWeb.Api.FavouriteView do
  def render("index.json", %{favourites: favourites}) do
    %{
      favourites: Enum.map(favourites, fn favourite -> favourite_json(favourite) end)
    }
  end

  def render("show.json", %{favourite: favourite}) do
    %{favourite: favourite_json(favourite)}
  end

  def render("deleted.json", _params) do
    %{deleted: "true"}
  end

  defp favourite_json(favourite) do
    %{
      id: favourite.id,
      number: favourite.number,
      user_id: favourite.user_id
    }
  end
end
