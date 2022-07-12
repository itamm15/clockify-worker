import Config

config :clockify_requester,
  api_key: ""

if System.get_env("CI") do
  System.get_env("api_key")
else
  import_config "dev.secret.exs"
end
