use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :t_rex_rest_phoenix, TRexRestPhoenix.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :t_rex_rest_phoenix, TRexRestPhoenix.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "t_rex_rest_phoenix_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
