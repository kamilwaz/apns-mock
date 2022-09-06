defmodule APNSMockWeb.MockController do
  use APNSMockWeb, :controller

  alias APNSMock.Activity
  alias APNSMock.Mock

  def index(conn, _params) do
    tokens =
      Mock.get_error_tokens()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:ok, tokens)
  end

  def update(conn, params) do
    Map.get(params, "_json")
    |> Enum.each(fn token ->
      {device_token, token} = Map.pop!(token, "device_token")
      status = Map.fetch!(token, "status")
      reason = Map.fetch!(token, "reason")

      Mock.add_error_token(device_token, %{status: status, reason: reason})
    end)

    conn
    |> send_resp(:ok, "")
  end

  def reset(conn, _params) do
    Mock.reset()
    Activity.reset()

    conn
    |> send_resp(:ok, "")
  end

  def activity(conn, _params) do
    activities =
      Activity.list()
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:ok, activities)
  end
end
