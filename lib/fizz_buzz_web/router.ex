defmodule FizzBuzzWeb.Router do
  use FizzBuzzWeb, :router

  alias FizzBuzz.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :put_secure_browser_headers
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/", FizzBuzzWeb do
    pipe_through :browser

    get "/", HomeController, :index
    resources "/accounts", UserController, except: [:index]
    resources "/favourites", FavouriteController, only: [:create, :delete]
    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    delete "/sign-out", SessionController, :delete
  end

  scope "/api/v1", FizzBuzzWeb do
    pipe_through :api

    post "/sign_up", Api.UserController, :create, as: :api_user
    post "/sign_in", Api.SessionController, :create, as: :api_session
    get "/play", Api.GameController, :play, as: :api_play
  end

  scope "/api/v1", FizzBuzzWeb do
    pipe_through [:api, :jwt_authenticated]

    resources "/favourites", Api.FavouriteController,
      only: [:create, :delete, :index, :show],
      as: :api_favourite

    get "/favourites/find_by_number/:number", Api.FavouriteController, :find_by_number,
      as: :api_favourite_by_number
  end
end
