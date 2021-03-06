defmodule ClockifyRequester.Integration.Clockify do
  # attributes
  @reports_api "https://reports.api.clockify.me/v1"
  @api "https://api.clockify.me/api/v1"

  @spec get(String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def get(endpoint) do
    url = @api <> endpoint
    headers = ["X-Api-Key": "#{get_api_key()}", "Content-Type": "application/json"]
    HTTPoison.get(url, headers)
  end

  @spec post(String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def post(endpoint) do
    url = @api <> endpoint
    headers = ["X-Api-Key": "#{get_api_key()}", "Content-Type": "application/json"]
    HTTPoison.post(url, headers)
  end

  @spec post_reports(String.t(), String.t(), String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def post_reports(endpoint, start_date, end_date) do
    url = @reports_api <> endpoint
    headers = ["X-Api-Key": "#{get_api_key()}", "Content-Type": "application/json"]

    body =
      %{
        "dateRangeStart" => "#{start_date}T00:00:00.000",
        "dateRangeEnd" => "#{end_date}T23:59:59.000",
        "summaryFilter" => %{
          "groups" => [
            "USER"
          ]
        }
      }
      |> Poison.encode!()

    HTTPoison.post(url, body, headers)
  end

  @spec post_time_entries(String.t(), String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def post_time_entries(endpoint, start_date, end_date, project_id, billable, description) do
    url = @api <> endpoint
    headers = ["X-Api-Key": "#{get_api_key()}", "Content-Type": "application/json"]

    body =
      %{
        "start" => "#{start_date}T08:00:00.000Z",
        "end" => "#{end_date}T15:59:34.000Z",
        "billable" => billable,
        "description" => description,
        "projectId" => project_id,
        "tagIds" => [],
        "customFields" => []
      }
      |> Poison.encode!()

    HTTPoison.post(url, body, headers)
  end

  @spec get_api_key :: String.t()
  defp get_api_key, do: Application.get_env(:clockify_requester, :api_key)
end
