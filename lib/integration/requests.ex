defmodule ClockifyRequester.Integration.Requests do
  alias ClockifyRequester.Integration.Clockify

  # delegations
  defdelegate get(endpoint), to: Clockify
  defdelegate post(endpoint), to: Clockify
  defdelegate post_reports(endpoint, start_date, end_date), to: Clockify

  defdelegate post_time_entries(
                endpoint,
                start_date,
                end_date,
                project_id,
                billable,
                description
              ),
              to: Clockify

  # requests

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

  @spec get_summary(String.t(), String.t()) ::
          {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def get_summary(start_date, end_date) do
    endpoint = "/workspaces/#{get_workspace_id()}/reports/summary"

    case post_reports(endpoint, start_date, end_date) do
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

  @spec get_users :: {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
  def get_users do
    endpoint = "/workspaces/#{get_workspace_id()}/users"

    case get(endpoint) do
      {:ok, response} ->
        Poison.decode!(response.body)

      {:error, error} ->
        raise error
    end
  end

  @spec get_time_entires_for_given_user(String.t()) :: list(map()) | String.t()
  def get_time_entires_for_given_user(email) do
    case Enum.empty?(get_user_id(email)) do
      false ->
        [%{"id" => user_id}] = get_user_id(email)
        endpoint = "/workspaces/#{get_workspace_id()}/user/#{user_id}/time-entries"

        case get(endpoint) do
          {:ok, response} ->
            Poison.decode!(response.body)

          {:error, error} ->
            raise error
        end

      true ->
        raise "Could not find the user."
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

  @spec get_user_id(String.t()) :: list(map())
  defp get_user_id(email) do
    get_users()
    |> Enum.filter(&(&1["email"] == email))
  end
end
