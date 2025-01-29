import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :autocomplete_testbed, AutocompleteTestbed.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "autocomplete_testbed_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :autocomplete_testbed, sql_sandbox: true

config :phoenix_test,
  otp_app: :autocomplete_testbed,
  endpoint: AutocompleteTestbedWeb.Endpoint,
  playwright: [
    cli: "assets/node_modules/playwright/cli.js",
    browser: [browser: :chromium],
    trace_dir: "tmp",
    js_logger:
      # Default to true if you like seeing log messages for errors during test
      if System.get_env("PLAYWRIGHT_LOG_JS_MESSSAGES", "false") in ~w(t true) do
        :default
      end
  ],
  timeout_ms: 2000

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :autocomplete_testbed, AutocompleteTestbedWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "sStEYH5JzPdA12jMHSGpcwVFLhSbjkGzBwC+VoXgkjIA//4c6/EzE+eF0V6hwdQa",
  server: true

# In test we don't send emails
config :autocomplete_testbed, AutocompleteTestbed.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :wallaby,
  otp_app: :autocomplete_testbed,
  base_url: "http://localhost:4002"
  # chromedriver: [
  #   headless: false
  # ]
