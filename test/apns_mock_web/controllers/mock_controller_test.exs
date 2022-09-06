defmodule APNSMockWeb.MockControllerTest do
  use APNSMockWeb.ConnCase

  alias APNSMock.Mock
  alias APNSMock.Activity

  @error_token %{
    "device_token" => "9ef4df1e-c9e1-4767-a464-8b27c3bcfeb9",
    "status" => 401,
    "reason" => "Unauthorized"
  }

  @activity %{
    "device_token" => "5b4fa311-54c0-4b3d-8f4e-8e83b50140a8",
    "request_headers" => %{
      "accept" => "*/*",
      "accept-encoding" => "gzip, deflate",
      "connection" => "keep-alive",
      "content-length" => "0",
      "host" => "localhost:4000",
      "user-agent" => "HTTPie/3.2.1"
    },
    "response_data" => %{
      "reason" => "Unauthorized"
    },
    "status" => 401
  }

  setup do
    Mock.reset()

    %{}
  end

  describe "index" do
    test "returns error tokens", %{conn: conn} do
      add_error_token(@error_token)

      conn = get(conn, Routes.mock_path(conn, :index))
      assert json_response(conn, :ok) == map([@error_token])
    end
  end

  describe "update" do
    test "adds error token", %{conn: conn} do
      conn = post(conn, Routes.mock_path(conn, :update), %{"_json" => [@error_token]})
      assert response(conn, :ok) == ""

      assert map([@error_token], &to_atom/1) == Mock.get_error_tokens()
    end

    test "update existing error token", %{conn: conn} do
      conn = post(conn, Routes.mock_path(conn, :update), %{"_json" => [@error_token]})
      assert response(conn, :ok) == ""

      modified_token = %{@error_token | "status" => 403, "reason" => "Forbidden"}
      conn = post(conn, Routes.mock_path(conn, :update), %{"_json" => [modified_token]})
      assert response(conn, :ok) == ""

      assert map([modified_token], &to_atom/1) == Mock.get_error_tokens()
    end
  end

  describe "reset" do
    test "deletes all error tokens", %{conn: conn} do
      add_error_token(@error_token)
      assert map([@error_token], &to_atom/1) == Mock.get_error_tokens()

      conn = post(conn, Routes.mock_path(conn, :reset))
      assert response(conn, :ok) == ""

      assert %{} == Mock.get_error_tokens()
    end

    test "deletes all activity", %{conn: conn} do
      add_error_token(@error_token)

      conn = get(conn, Routes.mock_path(conn, :index))
      assert json_response(conn, :ok) == map([@error_token])

      conn = post(conn, Routes.mock_path(conn, :reset))
      assert response(conn, :ok) == ""

      conn = get(conn, Routes.mock_path(conn, :index))
      assert json_response(conn, :ok) == %{}
    end
  end

  describe "activity" do
    test "returns activities", %{conn: conn} do
      Activity.add(to_atom(@activity))

      conn = get(conn, Routes.mock_path(conn, :activity))
      assert json_response(conn, :ok) == [@activity]
    end
  end

  defp add_error_token(token) do
    {device_token, token} = Map.pop!(token, "device_token")
    Mock.add_error_token(device_token, %{status: token["status"], reason: token["reason"]})
  end

  defp map(tokens, callback \\ & &1) do
    tokens
    |> Enum.map(fn token ->
      {device_token, token} = Map.pop!(token, "device_token")
      {device_token, callback.(token)}
    end)
    |> Map.new()
  end

  defp to_atom(map) do
    map
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
    |> Map.new()
  end
end
