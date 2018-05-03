# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chatty,
  ecto_repos: [Chatty.Repo]

# Configures the endpoint
config :chatty, ChattyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wm1xyR/9f89lECcxWhN1ayscKLJhFSgLPpi5il5OltjmUOCZEzaueiDP4ziQnZFg",
  render_errors: [view: ChattyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chatty.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Chatty.Coherence.User,
  repo: Chatty.Repo,
  module: Chatty,
  web_module: ChattyWeb,
  router: ChattyWeb.Router,
  messages_backend: ChattyWeb.Coherence.Messages,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :confirmable, :registerable]

config :coherence, ChattyWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
