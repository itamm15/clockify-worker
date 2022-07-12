import Config

config :clockify_requester,
  api_key: ""

if System.get_env("CI") do
  import_config("git_ci.exs")
else
  import_config("dev.secret.exs")
end
