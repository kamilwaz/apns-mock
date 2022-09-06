defmodule APNSMockWeb.APNSController do
  use APNSMockWeb, :controller

  alias APNSMock.APNS

  def create(conn, params) do
    {code, response} = APNS.send(conn.req_headers, params)
    response = Jason.encode!(response)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, response)
  end
end
