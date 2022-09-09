defmodule APNSMock.Mock do
  use Agent

  alias Plug.Conn

  @type result :: %{
          status: Conn.int_status(),
          reason: binary
        }

  @spec start_link(term) :: Agent.on_start()
  def start_link(_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec get_error_tokens() :: %{optional(binary) => result}
  def get_error_tokens() do
    Agent.get(__MODULE__, & &1)
  end

  @spec add_error_token(binary, result) :: :ok
  def add_error_token(device_token, token) do
    Agent.update(__MODULE__, &Map.put(&1, device_token, token))
  end

  @spec reset() :: :ok
  def reset() do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end
end
