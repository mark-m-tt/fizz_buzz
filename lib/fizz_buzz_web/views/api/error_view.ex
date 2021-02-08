defmodule FizzBuzzWeb.Api.ErrorView do
  use FizzBuzzWeb, :view

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  def render("raw_error.json", %{error: error}) do
    %{errors: error}
  end
end
