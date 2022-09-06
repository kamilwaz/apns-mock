import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :apns_mock, APNSMockWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6fAi7OFszMC6vqD2e+g/Xo6stqBVQkwvYrC9BIT9P69b04EGi/CxTbeqQ67p2uyV",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
