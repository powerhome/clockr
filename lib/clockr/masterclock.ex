defmodule Clockr.Masterclock do
  @moduledoc """
  Control node for an individual clock face
  """

  use GenServer
  import Clockr.MasterclockCrypt

  @multicast_addr '237.252.0.0'
  @clock_port 6168
  def clock_port, do: @clock_port

  @hdr1     [0x23, 0x81, 0xd7, 0x65]
  @hdr2     [0x10, 0xb3, 0x2f, 0xe1]
  @rsrv1    [0x00, 0x00]
  @family   [0x00, 0x00, 0x00, 0x80]
  @rsrv2    [0x00, 0x00, 0x00]
  @zeroes   [0x01] # Leading Zeroes (off): Set to 0x00 to enable
  @rsrv3    [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

  @controlcodes %{
    default: 0x00, # alias for :time
    time:    0x00,
    blank:   0x01,
    value:   0x02,
    dashes:  0x03,
  }

  # TODO: Format these docs better
  @doc """
    @option opts [Integer] :control_addr source control address, between 0 and 65535
    @option opts [String]  :clock_ip Direct IP address of the clock; defaults to MULTICAST_ADDR
  """
  def start_link(clock = %{control_source_id: control_source_id}, opts \\ []) do
    {control_source_id, _} = Integer.parse(control_source_id, 16)

    {:ok, clock_ip} = :inet.parse_address(clock[:clock_ip] || @multicast_addr)

    # TODO: Remember to close this socket on actor shutdown
    {:ok, socket} = :gen_udp.open(0)

    data = %{control_source_id: control_source_id, clock_ip: clock_ip, socket: socket}
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

  defp packetize({mode, hms}, control_source_id) do
    @hdr1 ++
    @hdr2 ++
    @rsrv1 ++
    [control_source_id] ++
    @family ++
    @rsrv2 ++
    @zeroes ++
    @rsrv3 ++
    [@controlcodes[mode]] ++
    [hms.s, hms.h, hms.m]
  end

  defp clock_send(data, socket, clock_ip) do
    # TODO: Error handling
    :gen_udp.send(socket, clock_ip, @clock_port, data)
  end
end
