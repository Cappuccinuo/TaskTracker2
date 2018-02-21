# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tasktracker,
  ecto_repos: [Tasktracker.Repo]

# Configures the endpoint
config :tasktracker, TasktrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "A3N5YzN8PjHMnS2ZMAh+ym6eIsu/uNZ9U2tmQbNSGYpYkWzmLdudCmHRr/fUTd9A",
  render_errors: [view: TasktrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tasktracker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "TaskTracker",
  ttl: {30, :days},
  verify_issuer: true,
  verify_module: Guardian.JWT,
  serializer: TasktrackerWeb.GuardianSerializer,
  secret_key: "anUG...A4qfP5"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
