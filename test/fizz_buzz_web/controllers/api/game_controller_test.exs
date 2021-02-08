defmodule FizzBuzzWeb.Api.GameControllerTest do
  use FizzBuzzWeb.ConnCase
  use ExUnit.Case

  describe "play/2" do
    setup :create_conn

    test "renders the default fizz_buzz numbers when given no params", %{conn: conn} do
      conn = get(conn, Routes.api_play_path(conn, :play))
      result = json_response(conn, 200)["fizz_buzzes"]
      assert Enum.at(result, 0) == %{"number" => 1, "result" => "1"}
      assert Enum.at(result, 99) == %{"number" => 100, "result" => "buzz"}
      assert Enum.count(result) == 100
    end

    test "passes through the corrent params when given", %{conn: conn} do
      conn = get(conn, Routes.api_play_path(conn, :play, starting_number: 10, count: 5))
      result = json_response(conn, 200)["fizz_buzzes"]
      assert Enum.at(result, 0) == %{"number" => 10, "result" => "buzz"}
      assert Enum.at(result, 4) == %{"number" => 14, "result" => "14"}
      assert Enum.count(result) == 5
    end

    test "returns a 422 when given an invalid starting number", %{conn: conn} do
      conn = get(conn, Routes.api_play_path(conn, :play, starting_number: -10, count: 10))
      assert json_response(conn, 422) == %{"errors" => "must be a positive starting number"}
    end

    test "returns a 422 when given an invalid count", %{conn: conn} do
      conn = get(conn, Routes.api_play_path(conn, :play, starting_number: 10, count: -10))
      assert json_response(conn, 422) == %{"errors" => "must be a positive count"}
    end
  end

  def create_conn(_) do
    conn = build_conn()

    %{conn: conn}
  end
end
