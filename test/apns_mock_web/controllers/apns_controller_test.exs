defmodule APNSMockWeb.APNSControllerTest do
  use APNSMockWeb.ConnCase

  alias APNSMock.Mock

  @notification %{
    device_token: "b48775f2-fcb1-4558-afc4-966724ec7f5f",
    params: %{"aps" => %{"alert" => "Hello"}}
  }

  setup do
    Mock.reset()

    %{}
  end

  describe "create" do
    test "returns OK", %{conn: conn} do
      conn = post_notification(conn, @notification)
      assert json_response(conn, :ok) == nil
    end

    test "returns mocked error", %{conn: conn} do
      Mock.add_error_token(@notification.device_token, %{status: 401, reason: "Unauthorized"})

      conn = post_notification(conn, @notification)
      assert json_response(conn, 401) == %{"reason" => "Unauthorized"}
    end
  end

  defp post_notification(conn, %{device_token: device_token, params: params}) do
    post(conn, Routes.apns_path(conn, :create, device_token), params)
  end
end
