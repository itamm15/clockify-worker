defmodule ClockifyRequester.Integration.ClockifyTest do
  use ExUnit.Case, async: true
  alias ClockifyRequester.Integration.Clockify
  alias ClockifyRequester.Integration.Requests

  describe "get" do
    test "for valid get request, return status_code 200" do
      endpoint = "/workspaces"
      {:ok, result} = Clockify.get(endpoint)
      %{status_code: code} = result
      assert code == 200
    end
  end

  describe "post_reports" do
    test "for valid post_reports request, return status_code 200" do
      workspace_id = Requests.get_workspace_id
      endpoint = "/workspaces/#{workspace_id}/reports/summary"
      {:ok, result} = Clockify.post_reports(endpoint, Date.utc_today, Date.utc_today)
      %{status_code: code} = result
      assert 200 == code
    end
  end

  describe "post_time_entries" do
    test "for valid post_time_entries request, return status_code 200" do
      workspace_id = Requests.get_workspace_id
      endpoint = "/workspaces/#{workspace_id}/time-entries"
      {:ok, result} = Clockify.post_time_entries(endpoint, "2022-06-05", "2022-06-06", "62caf30eacffdf336003da32", false, "test request")
      %{status_code: code} = result
      assert 201 == code
    end
  end

end
