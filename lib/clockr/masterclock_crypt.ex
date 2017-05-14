defmodule Clockr.MasterclockCrypt do
  @moduledoc """
  Utilities for managing encrypted Masterclock packets
  """

  use Bitwise

  @prog_key {0x74, 0x12, 0x02, 0xfb, 0xcc, 0x24, 0x5b, 0x82, 0x61, 0xe7, 0x3f, 0x9a, 0x26, 0x7c, 0xd3, 0xa0, 0x42}

  @doc """
    Transforms a list bytes using the Masterclock algorithm
    data should be a list of bytes to be encrypted
    Returns binary string
  """
  @spec mccrypt([any()]) :: binary()
  def mccrypt(data) do
    {bytes, _, _} = Enum.reduce data, {[], 1, 0}, fn(inbyte, acc) ->
      {bytes, padcnt, keycnt} = acc
      {newbyte, newpadcnt, newkeycnt} = mccrypt_byte({inbyte, padcnt, keycnt})

      {bytes ++ [newbyte], newpadcnt, newkeycnt}
    end
    bytes
  end

  defp mccrypt_byte({byte, padcnt, keycnt}) do
    crypted_byte = (byte ^^^ padcnt ^^^ elem(@prog_key, keycnt))

    newpadcnt = if(padcnt < 254, do: padcnt + 1, else: 1)

    newkeycnt = if(keycnt + 1 >= tuple_size(@prog_key), do: 0, else: keycnt + 1)

    {crypted_byte, newpadcnt, newkeycnt}
  end
end
