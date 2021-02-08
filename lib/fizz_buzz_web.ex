defmodule FizzBuzzWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use FizzBuzzWeb, :controller
      use FizzBuzzWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: FizzBuzzWeb

      import Plug.Conn
      import FizzBuzzWeb.Gettext

      import FizzBuzzWeb.Helpers.Auth,
        only: [current_user_id: 1, current_user: 1, user_from_jwt: 1]

      import FizzBuzzWeb.Helpers.ControllerHelpers,
        only: [default_fizz_buzz_list: 0, default_calculator: 0]

      alias FizzBuzzWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/fizz_buzz_web/templates",
        namespace: FizzBuzzWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      import FizzBuzzWeb.Helpers.Auth,
        only: [signed_in?: 1, current_user: 1]

      import FizzBuzzWeb.Helpers.ViewHelpers,
        only: [number_is_favourited?: 2, favourite_for_number: 2]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import FizzBuzzWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import FizzBuzzWeb.ErrorHelpers
      import FizzBuzzWeb.Gettext
      alias FizzBuzzWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
