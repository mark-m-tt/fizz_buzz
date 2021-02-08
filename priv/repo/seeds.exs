# Create a default user with some favourites

alias FizzBuzz.Repo
alias FizzBuzz.Accounts

attrs = %{username: "username", password: "password", password_confirmation: "password"}
user = %Accounts.User{} |> Accounts.User.changeset(attrs) |> Repo.insert!()

Enum.each([3, 5, 10], fn number ->
  %Accounts.Favourite{}
  |> Accounts.Favourite.changeset(%{number: number, user_id: user.id})
  |> Repo.insert!()
end)
