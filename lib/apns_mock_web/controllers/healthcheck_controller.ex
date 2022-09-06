defmodule APNSMockWeb.HealthCheckController do
  use APNSMockWeb, :controller

  def index(conn, _params) do
    conn
    |> send_resp(:ok, "")
  end
end
