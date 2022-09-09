defmodule APNSMock.Activity do
  use Agent

  alias Plug.Conn

  @type t :: %{
          device_token: binary,
          request_headers: %{optional(binary) => binary},
          request_data: Conn.params(),
          status: Conn.int_status(),
          response_data: map | nil
        }

  @spec start_link(term) :: Agent.on_start()
  def start_link(_arg) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @spec list() :: [t]
  def list() do
    Agent.get(__MODULE__, & &1)
  end

  @spec add(t) :: :ok
  def add(activity) do
    Agent.update(__MODULE__, &[activity | &1])
  end

  @spec reset() :: :ok
  def reset() do
    Agent.update(__MODULE__, fn _ -> [] end)
  end
end
