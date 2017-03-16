# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :t_rex_rest_phoenix,
  ecto_repos: [TRexRestPhoenix.Repo]

# Configures the endpoint
config :t_rex_rest_phoenix, TRexRestPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ul3x/c/7qX95WHZVZeew7fEqMNv2JMM+mwARiAYyXaWotAi4rmrtHEQdGvNkO7A0",
  render_errors: [view: TRexRestPhoenix.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TRexRestPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Phoenix Security
config :t_rex_rest_phoenix, t_rex_security: [
    username: "t-rex",
    password: "t-rex@2nt%Elixir9",
    realm: "Admin Area"
  ]

# Configure Pagination
config :rummage_ecto, Rummage.Ecto,
  default_repo: TRexRestPhoenix.Repo,
  default_per_page: 10

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
