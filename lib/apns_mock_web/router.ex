defmodule APNSMockWeb.Router do
  use APNSMockWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/mock", APNSMockWeb do
    pipe_through :api

    get "/error-tokens", MockController, :index
    post "/error-tokens", MockController, :update
    put "/error-tokens", MockController, :update

    post "/reset", MockController, :reset
    put "/reset", MockController, :reset

    get "/activity", MockController, :activity
  end

  scope "/", APNSMockWeb do
    get "/healthcheck", HealthCheckController, :index

    post "/3/device/:device_token", APNSController, :create
  end
end
