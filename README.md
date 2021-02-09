# FizzBuzz

Welcome to my Fizz Buzz application!

### Getting up and running

 - `$ git clone git@github.com:mark-m-tt/fizz_buzz.git`
 - `$ cd fizz_buzz`
 - `$ docker-compose build`
 - `$ docker-compose up`
 - Head to localhost:4000

### Features of the browser app
- Create your account or login with the seeded account (username and password are username and password) and start fizzbuzzing!
- Page number and page size can be set from localhost:4000/
- Add and remove your favourite numbers

### API Endpoints
#### Unauthenticated

| Action | Endpoint | params | status | notes
| ------ | ----------- | ---------- | -------- | ------ |
|get|/api/v1/play|OPTIONAL { starting_number:, count: }|200 or 422|defaults to 1 and 15 respectively
|post|/api/v1/sign-up|{ user: { username:, password:, password_confirmation: } } | 204 or 422|registers and returns a JWT
|post|/api/v1/sign-in|{ session: { username:, password: } }|200 or 401|returns a JWT

#### Authenticated
These routes require a valid JWT provided in the header as per https://jwt.io/introduction
Failure to do this will result in a 401 response
| Action | Endpoint | params | status | notes
| ------ | ----------- | ---------- | -------- | -------- |
|GET|api/v1/favourites|-|200|list all your favourites
|POST|api/v1/favourites|{ favourite: { number: } }|204 or 422|doesn't allow duplicates
|GET|api/v1/favourites/:id|-|200 or 404|find a favourite record by ID
|DELETE|api/v1/favourites/:id|-|200 or 404|delete a record by ID|
|GET|api/v1/favourites/find_by_number/:number|-|200 or 404|scoped to the JWT's account

### Running the API Client
- After bringing up the main project with docker-compose up, run
- `$ docker exec -it fizz_buzz_client_1 irb -r ./client.rb`
- This will bring you into an interactive irb session, and allow you to execute the following commands
 
### API Client methods
| Command | Arguments | Description |
| ------ | ----------- | ---------- |
| client = Client.new()|username:, password:|Sets up a new client object for future calls. If the given username and password are valid, will auto login before authenticated routes|
|client.play|starting_number:, count:|Plays FizzBuzz! The arguments here are optional, defaulting at 1 and 15 respectively|
|client.register|password_confirmation:|Creates a new account with the initialized username and password arguments|
|client.list_favourites||Lists all favourites for the given JWT's account|
|client.make_favourite|number:|Makes the given number a favourite for the JWT's account|
|client.remove_favourite|number:|Removes the given number from the JWT's account's favourites|

### Using the API Client from within IRB
```
irb(main):001:0> client = Client.new(username: ${username}, password: ${password})` # Sets up the client
    => #<Client:0x00005606cf41c860 @username="bla", @password="123123123">
irb(main):002:0> client.register(password_confirmation: '123123123') # registers a new account
    => #<HTTParty::Response:0x16d78 parsed_response={"jwt"=> jwt...}
irb(main):003:0> client.play # Plays Fizz Buzz! Takes 'starting_number' and 'count' named_params, which default to 1 and 15 respectively
    => {"fizz_buzzes"=>[{"number"=>1, "result"=>"1"}, {"number"=>2, "result"=>"2"}, {"number"=>3, "result"=>"fizz"}...
irb(main):004:0> client.list_favourites # lists the current_user's favourite numbers
    => {"favourites"=>[]}
irb(main):005:0> client.make_favourite(number: ${number}) # creates a new favourite for the current_user
    => {"favourite"=>{"id"=>x, "number"=>1, "user_id"=>x}}
irb(main):006:0> client.make_favourite(number: 2)
    => {"favourite"=>{"id"=>x, "number"=>2, "user_id"=>x}}
irb(main):007:0> client.list_favourites
    => {"favourites"=>[{"id"=>x, "number"=>1, "user_id"=>x}, {"id"=>x, "number"=>2, "user_id"=>x}]}
irb(main):008:0> client.remove_favourite(number: 1) # removes a favourite number
    => {"deleted"=>"true"}
irb(main):010:0> client.list_favourites
    => {"favourites"=>[{"id"=>x, "number"=>2, "user_id"=>x}]
```

### Running tests and linters

##### API Tests
 - `$ docker-compose run phoenix bash` from the project root
 - And then from within the container:
 - `$ mix format`
 - `$ mix credo --strict`
 - `$ mix test`
#### Client Tests
- `$ docker-compose run client bash` from the project root
- And then from within the container
- `$ rubocop`
- `$ rspec`

### Notes
- Secrets and Env files have been uploaded for reviewer ease. There are no sensitive keys in this repo and ths would not be done outside of a technical test
- Warnings come from guardian's supplied code - have decided to leave it as they have on their github
- Deprecation warnings are both being fixed in PR's in their respective repos, but are yet to make it live

### Nice to haves if I had more time
- Properly implemented pagination (All the logic is there - just need to apply next / last buttons)
- Implement password reset / email confirmation
- Have some more fun with fizz_buzz, random numbers etc...
