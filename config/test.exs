import Config

config :clockify_requester,
  api_key: ""

  System.get_env("api_key")
