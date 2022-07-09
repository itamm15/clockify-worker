defmodule ClockifyRequester.Integration.Requests do
  alias ClockifyRequester.Integration.Clockify

  # delegations
  defdelegate get(endpoint), to: Clockify

  # functions

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

  defp extract_workspaces_from_response({:ok, response}) do
    [%{"id" => id}] = response
    id
  end
end
