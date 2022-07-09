defmodule ClockifyRequester.Integration.Requests do
  alias ClockifyRequester.Integration.Clockify

  # delegations
  defdelegate get(endpoint), to: Clockify

  # functions

  @spec get_workspace_id ::   {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
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

  ## Privates

  @spec extract_workspaces_from_response(tuple()) :: String.t()
  defp extract_workspaces_from_response({:ok, response}) do
    [%{"id" => id}] = response
    id
  end
end
