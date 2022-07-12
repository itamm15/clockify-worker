import Config

config :clockify_requester,
  api_key: ""

System.get_env("API_KEY")
