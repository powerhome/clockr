defmodule Clockr.Masterclock do
  @moduledoc """
  Control node for an individual clock face
  """

  use GenServer
  import Clockr.MasterclockCrypt
  import Clockr.MasterclockEncoder

  @multicast_addr '237.252.0.0'
  @clock_port 6168
  def clock_port, do: @clock_port

  @doc """
    The clock properties are:

    control_addr: The binary string representation of the source control address, between 0 and 65535.
      Uniquely identifies the controlling processs.
    clock_ip: IP address of the clock as a charlist; defaults to MULTICAST_ADDR if not specified.
  """
  def start_link(clock = %{control_source_id: control_source_id}, opts \\ []) do
    {control_source_id, _} = Integer.parse(control_source_id, 16)
    padded_control_source_id = case byte_size(:binary.encode_unsigned(control_source_id)) do
      1 ->
        {0, control_source_id}
      _ ->
        {control_source_id}
    end

    {:ok, clock_ip} = :inet.parse_address(clock[:clock_ip] || @multicast_addr)

    {:ok, socket} = :gen_udp.open(0)
    Process.link(socket)

    data = %{control_source_id: padded_control_source_id, clock_ip: clock_ip, socket: socket}
    GenServer.start_link(__MODULE__, data, opts)
  end

  def show(pid, mode, hms = %{h: _, m: _, s: _}) do
    GenServer.call(pid, {:show, mode, hms})
  end
  def show(pid, mode, %{h: h, m: m}) do
    show(pid, mode, %{h: h, m: m, s: 0})
  end
  def show(pid, mode) do
    # Used for modes :blank, :time, :dashes
    show(pid, mode, %{h: 0, m: 0, s: 0})
  end

  def handle_call({:show, mode, hms}, _from, state) do
    {mode, hms}
    |> packetize(state.control_source_id)
    |> mccrypt
    |> clock_send(state.socket, state.clock_ip)

    {:reply, :ok, state}
  end

  defp clock_send(data, socket, clock_ip) do
    :ok = :gen_udp.send(socket, clock_ip, @clock_port, data)
  end
end
