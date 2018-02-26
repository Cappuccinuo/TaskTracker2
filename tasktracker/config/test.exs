use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tasktracker2 TasktrackerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :tasktracker2, Tasktracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "task",
  password: "123456",
  database: "tasktracker2_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
