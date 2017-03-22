defmodule TRexRestPhoenix.Router do
  use TRexRestPhoenix.Web, :router

  pipeline :api do
    plug CORSPlug, [origin: "*"]
    plug BasicAuth, use_config: {:t_rex_rest_phoenix, :t_rex_security}
    plug :accepts, ["json"]
  end

  scope "/api/v1", TRexRestPhoenix do
    pipe_through :api

      # account route
      resources "/accounts", AccountController
      options "/accounts", AccountController, :options

      # login route
      post "/login", AccountController, :login
      options "/login", AccountController, :options

      # catetory route
      resources "/categories", CategoryController
      options "/categories", CategoryController, :options

      # author route
      resources "/authors", AuthorController
      options "/authors", AuthorController, :options

      #user profile route
      resources "/user_profile", UserProfileController
      options "/user_profile", UserProfileController, :options

      #book route
      resources "/books", BookController
      options "/books", BookController, :options

      #carts route
      resources "/carts", CartController
      options "/carts", CartController, :options

      get "/carts/user/:id", CartController, :showBookInCart
      options "/carts/user/:id", CartController, :options

      delete "/carts/user/:id/book/:book_id", CartController, :deleteBookFromCart
      options "/carts/user/:id/book/:book_id", CartController,  :options

      #checkout route
      resources "/checkouts", CheckoutController
      options "/checkouts", CheckoutController, :options

      #checkout detail
      resources "/checkout_detail", CheckoutDetailController
      options "/checkout_detail", CheckoutDetailController, :options
  end

  # Other scopes may use custom stacks.
  # scope "/api", TRexRestPhoenix do
  #   pipe_through :api
  # end
end
