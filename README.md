# Mango
E-commerce Application built following [Mastering Phoenix Framework](https://shankardevy.com/phoenix-book) book written by @shankardevy


## Run the application locally:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Seed the database with `mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Run tests:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install` 
  * Run phantomjs `phantomjs --wd`
  * Run all tests in another tab using `mix test`
