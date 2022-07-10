defmodule ClockifyRequester.Integration.Requests do
  alias ClockifyRequester.Integration.Clockify

  # delegations
  defdelegate get(endpoint), to: Clockify
  defdelegate post(endpoint), to: Clockify
  defdelegate post_reports(endpoint), to: Clockify

  defdelegate post_time_entries(
                endpoint,
                start_date,
                end_date,
                project_id,
                billable,
                description
              ),
              to: Clockify

  # functions

  @spec get_workspace_id :: {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def get_workspace_id do
    endpoint = "/workspaces"

    case get(endpoint) do
      {:ok, response} ->
        Poison.decode(response.body)
        |> extract_workspaces_from_response

      {:error, error} ->
        raise error
    end
  end

  @spec get_summary :: {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def get_summary do
    endpoint = "/workspaces/#{get_workspace_id()}/reports/summary"

    case post_reports(endpoint) do
      {:ok, response} ->
        Poison.decode!(response.body)

      {:error, error} ->
        raise error
    end
  end

  @spec get_projects :: {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def get_projects do
    endpoint = "/workspaces/#{get_workspace_id()}/projects"

    case get(endpoint) do
      {:ok, response} ->
        Poison.decode!(response.body)

      {:error, error} ->
        raise error
    end
  end

  @spec create_time_entry(String.t(), String.t(), String.t(), String.t(), String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def create_time_entry(start_date, end_date, project_id, billable, description) do
    endpoint = "/workspaces/#{get_workspace_id()}/time-entries"

    case post_time_entries(endpoint, start_date, end_date, project_id, billable, description) do
      {:ok, response} ->
        Poison.decode(response.body)

      {:error, error} ->
        raise error
    end
  end

  ## Privates

  @spec extract_workspaces_from_response(tuple()) :: String.t()
  defp extract_workspaces_from_response({:ok, response}) do
    [%{"id" => id}] = response
    id
  end
end
