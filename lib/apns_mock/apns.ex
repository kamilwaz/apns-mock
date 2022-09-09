defmodule APNSMock.APNS do
  alias APNSMock.Activity
  alias APNSMock.Mock
  alias Plug.Conn

  @spec send(Conn.headers(), Conn.params()) :: {Conn.int_status(), map | nil}
  def send(headers, params) do
    {device_token, params} = Map.pop!(params, "device_token")

    error_token =
      Mock.get_error_tokens()
      |> Map.get(device_token)

    case error_token do
      nil ->
        {200, nil}

      %{reason: reason, status: status} ->
        {status, %{reason: reason}}
    end
    |> tap(fn {status, body} ->
      activity = %{
        device_token: device_token,
        request_headers: Map.new(headers),
        request_data: params,
        status: status,
        response_data: body
      }

      Activity.add(activity)
    end)
  end
end
