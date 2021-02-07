defmodule FizzBuzz.AccountsTest do
  use FizzBuzz.DataCase

  alias FizzBuzz.Accounts

  import FizzBuzz.Factory

  describe "users" do
    alias FizzBuzz.Accounts.User

    @valid_attrs %{encrypted_password: "some encrypted_password", username: "some username"}
    @update_attrs %{
      encrypted_password: "some updated encrypted_password",
      username: "some updated username"
    }
    @invalid_attrs %{encrypted_password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      insert(:user, attrs)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "get_by_username/1 returns nil when given nil as an argument" do
      assert Accounts.get_by_username(nil) == nil
    end

    test "get_by_username/1 gets the user by username" do
      user = user_fixture(%{username: "user"})
      assert Accounts.get_by_username("user") == user
    end
  end

  describe "favourites" do
    alias FizzBuzz.Accounts.Favourite

    @valid_attrs %{user_id: 1, number: 1}
    @invalid_attrs %{user_id: 1, number: nil}

    def favourite_fixture do
      insert(:favourite)
    end

    test "create_favourite/1 with valid data creates a favourite" do
      insert(:user, id: 1)
      assert {:ok, %Favourite{} = _favourite} = Accounts.create_favourite(@valid_attrs)
    end

    test "create_favourite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_favourite(@invalid_attrs)
    end

    test "delete_favourite/1 deletes the favourite" do
      favourite = favourite_fixture()
      assert {:ok, %Favourite{}} = Accounts.delete_favourite(favourite)
    end
  end
end
