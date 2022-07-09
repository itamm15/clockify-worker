defmodule ClockifyRequester.Integration.Clockify do
  # attributes
  @api "https://api.clockify.me/api/v1"

  @spec get(String.t(), String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  defp get(token, endpoint) do
    url = @api <> endpoint
    headers = ["X-Api-Key": "#{token}", "Content-Type": "applications/json"]
    HTTPoison.get(url, headers)
  end
end
