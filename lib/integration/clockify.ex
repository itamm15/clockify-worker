defmodule ClockifyRequester.Integration.Clockify do
  # attributes
  @api "https://api.clockify.me/api/v1"

  @spec get(String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def get(endpoint) do
    url = @api <> endpoint
    headers = ["X-Api-Key": "#{get_api_key()}", "Content-Type": "applications/json"]
    HTTPoison.get(url, headers)
  end

  @spec get_api_key :: String.t()
  defp get_api_key, do: Application.get_env(:clockify_requester, :api_key)
end
