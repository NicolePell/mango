defmodule MangoWeb.Router do
  use MangoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MangoWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/categories/:name", CategoryController, :show

    get "/login", SessionController, :new
    post "/login", SessionController, :create

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
  end
end
