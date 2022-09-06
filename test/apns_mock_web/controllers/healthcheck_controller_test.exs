defmodule APNSMockWeb.HealthCheckControllerTest do
  use APNSMockWeb.ConnCase

  describe "index" do
    test "returns OK", %{conn: conn} do
      conn = get(conn, Routes.health_check_path(conn, :index))
      assert response(conn, :ok) == ""
    end
  end
end
