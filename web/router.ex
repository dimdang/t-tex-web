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
      options "/accounts/:id", AccountController, :options

      # login route
      post "/login", AccountController, :login
      options "/login", AccountController, :options

      # catetory route
      resources "/categories", CategoryController
      options "/categories", CategoryController, :options
      get "/category/:id", CategoryController, :tmpDelete
      options "/categories/:id", CategoryController, :options

      # author route
      resources "/authors", AuthorController
      options "/authors", AuthorController, :options
      get "/author/:id", AuthorController, :tmpDelete
      options "/authors/:id", AuthorController, :options

      #user profile route
      resources "/user_profile", UserProfileController
      options "/user_profile", UserProfileController, :options
      options "/user_profile/:id", UserProfileController, :options

      #book route
      resources "/books", BookController
      options "/books", BookController, :options
      get "/book/:id", BookController, :tmpDelete
      options "/books/:id", BookController, :options
      get "/book-feature", BookController, :bookFeatures
      options "/book-feature", BookController, :options

      #carts route
      resources "/carts", CartController
      options "/carts", CartController, :options
      options "/carts/:id", CartController, :options

      get "/carts/user/:id", CartController, :showBookInCart
      options "/carts/user/:id", CartController, :options

      #checkout route
      resources "/checkouts", CheckoutController
      options "/checkouts", CheckoutController, :options

      post "/payment", CheckoutController, :payment
      options "/payment", CheckoutController, :options

      #checkout detail
      resources "/checkout_detail", CheckoutDetailController
      options "/checkout_detail", CheckoutDetailController, :options

      #content who we are
      resources "/who_we_are", WhoWeAreController
      options "/who_we_are", WhoWeAreController, :options
  end

  # Other scopes may use custom stacks.
  # scope "/api", TRexRestPhoenix do
  #   pipe_through :api
  # end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :t_rex_rest_phoenix, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "T-Tex-Web"
      }
    }
  end
end
