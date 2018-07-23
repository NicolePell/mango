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

  pipeline :frontend do
    plug MangoWeb.Plugs.FetchCart
    plug MangoWeb.Plugs.LoadCustomer
  end

  scope "/", MangoWeb do
    pipe_through [:browser, :frontend]

    get "/", PageController, :index

    get "/categories/:name", CategoryController, :show

    get "/login", SessionController, :new
    post "/login", SessionController, :create

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/cart", CartController, :show
    post "/cart", CartController, :add
    put "/cart", CartController, :update

  end

  scope "/", MangoWeb do
    pipe_through [:browser, :frontend, MangoWeb.Plugs.AuthenticateCustomer]

    get "/checkout", CheckoutController, :edit
    put "/checkout/confirm", CheckoutController, :update

    get "/logout", SessionController, :delete
  end

end
