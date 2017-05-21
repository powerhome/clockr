defmodule Clockr.MasterclockTest do
  use ExUnit.Case

  setup do
    :gen_udp.open(Clockr.Masterclock.clock_port)

    {:ok, clock} = Clockr.Masterclock.start_link(%{control_source_id: "1", clock_ip: '127.0.0.1'})
    {:ok, clock: clock}
  end

  test "dispatches blank as appropriate control packet", %{clock: clock} do
    Clockr.Masterclock.show(clock, :blank)
    assert_receive {
      :udp, _, "127.0.0.1", _,
      [0x56, 0x91, 0xD6, 0x9A, 0xD9, 0x91, 0x73, 0x6B, 0x68, 0xED, 0x34, 0x97, 0x2B, 0x72, 0xDC, 0x30, 0x53, 0x66, 0x01, 0x17, 0xEE, 0xDA, 0x33, 0x43, 0x9B, 0x7B, 0xFC, 0x23, 0x87, 0x38, 0x63, 0xF3, 0x81, 0x60, 0x57, 0x36, 0x27, 0xDD, 0xEB, 0x0C, 0x72, 0xA8, 0x4A, 0xCB, 0x13, 0xB4, 0x09, 0x4C]
    }
  end

  test "dispatches dashes as appropriate control packet", %{clock: clock} do
    Clockr.Masterclock.show(clock, :dashes)
    assert_receive {
      :udp, _, "127.0.0.1", _,
      [0x56, 0x91, 0xD6, 0x9A, 0xD9, 0x91, 0x73, 0x6B, 0x68, 0xED, 0x34, 0x97, 0x2B, 0x72, 0xDC, 0x30, 0x53, 0x66, 0x01, 0x17, 0xEE, 0xDA, 0x33, 0x43, 0x9B, 0x7B, 0xFC, 0x23, 0x87, 0x38, 0x63, 0xF3, 0x81, 0x60, 0x57, 0x36, 0x27, 0xDD, 0xEB, 0x0C, 0x72, 0xA8, 0x4A, 0xCB, 0x11, 0xB4, 0x09, 0x4C]
    }
  end

  test "dispatches time as appropriate control packet", %{clock: clock} do
    Clockr.Masterclock.show(clock, :time)
    assert_receive {
      :udp, _, "127.0.0.1", _,
      [0x56, 0x91, 0xD6, 0x9A, 0xD9, 0x91, 0x73, 0x6B, 0x68, 0xED, 0x34, 0x97, 0x2B, 0x72, 0xDC, 0x30, 0x53, 0x66, 0x01, 0x17, 0xEE, 0xDA, 0x33, 0x43, 0x9B, 0x7B, 0xFC, 0x23, 0x87, 0x38, 0x63, 0xF3, 0x81, 0x60, 0x57, 0x36, 0x27, 0xDD, 0xEB, 0x0C, 0x72, 0xA8, 0x4A, 0xCB, 0x12, 0xB4, 0x09, 0x4C]
    }
  end

  test "dispatches value as appropriate control packet", %{clock: clock} do
    Clockr.Masterclock.show(clock, :value, %{h: 12, m: 30, s: 0})
    assert_receive {
      :udp, _, "127.0.0.1", _,
      [0x56, 0x91, 0xD6, 0x9A, 0xD9, 0x91, 0x73, 0x6B, 0x68, 0xED, 0x34, 0x97, 0x2B, 0x72, 0xDC, 0x30, 0x53, 0x66, 0x01, 0x17, 0xEE, 0xDA, 0x33, 0x43, 0x9B, 0x7B, 0xFC, 0x23, 0x87, 0x38, 0x63, 0xF3, 0x81, 0x60, 0x57, 0x36, 0x27, 0xDD, 0xEB, 0x0C, 0x72, 0xA8, 0x4A, 0xCB, 0x10, 0xB4, 0x05, 0x52]
    }
  end
end
