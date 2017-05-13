defmodule Clockr.Masterclock do

  @broadcast_addr "237.252.0.0"
  @clock_port 6168

  @hdr1     {0x23,0x81,0xd7,0x65}
  @hdr2     {0x10,0xb3,0x2f,0xe1}
  @rsrv1    {0x00,0x00}
  @family   {0x00,0x00,0x00,0x80}
  @rsrv2    {0x00,0x00,0x00}
  @zeroes   {0x01} # Leading Zeroes (off): Set to 0x00 to enable
  @rsrv3    {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}

  @controlcodes %{
    default: 0x00, # alias for :time
    time:    0x00,
    blank:   0x01,
    value:   0x02,
    dashes:  0x03,
  }


  end




  end
end
