# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ectopic_social_tool,
  ecto_repos: [EctopicSocialTool.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :ectopic_social_tool, EctopicSocialToolWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: EctopicSocialToolWeb.ErrorHTML, json: EctopicSocialToolWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: EctopicSocialTool.PubSub,
  live_view: [signing_salt: "KeXPbmMo"]

config :ectopic_social_tool,
       :http_linkedin_client,
       EctopicSocialTool.ExternalApi.LinkedinClient

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ectopic_social_tool, EctopicSocialTool.Mailer, adapter: Swoosh.Adapters.Local

config :ectopic_social_tool, Oban,
  repo: EctopicSocialTool.Repo,
  plugins: [{Oban.Plugins.Pruner, max_age: 180}],
  queues: [default: 10, publishers: 50]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
