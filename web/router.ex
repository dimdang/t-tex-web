defmodule TRexRestPhoenix.Router do
  use TRexRestPhoenix.Web, :router

  pipeline :api do
    plug CORSPlug, [origin: "*"]
    plug BasicAuth, use_config: {:t_rex_rest_phoenix, :t_rex_security}
    plug :accepts, ["json"]
  end

  scope "/api/v1", TRexRestPhoenix do
    pipe_through :api
      resources "/accounts", AccountController
      options "/accounts", AccountController, :options

      post "/login", AccountController, :login
  end

  # Other scopes may use custom stacks.
  # scope "/api", TRexRestPhoenix do
  #   pipe_through :api
  # end
end
