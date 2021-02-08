defmodule FizzBuzzWeb.Router do
  use FizzBuzzWeb, :router

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

  scope "/", FizzBuzzWeb do
    pipe_through :browser

    get "/", HomeController, :index
    resources "/accounts", UserController, except: [:index]
    resources "/favourites", FavouriteController, only: [:create, :delete]
    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
    delete "/sign-out", SessionController, :delete
  end

  scope "/api/v1", FizzBuzzWeb do
    pipe_through :api

    post "/sign-up", Api.UserController, :create, as: :api_user
    post "/sign-in", Api.SessionController, :create, as: :api_session
    get "/", Api.HomeController, :play_fizz_buzz, as: :api_fizz_buzz
  end
end
