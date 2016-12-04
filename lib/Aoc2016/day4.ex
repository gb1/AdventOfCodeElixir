defmodule Aoc.Aoc2016.Day4 do



  @doc ~S"""
  Detect real rooms, checksum equals the first 5 most common letters

  ##Tests
  iex>Aoc.Aoc2016.Day4.is_a_real_room?("not-a-real-room-404[oarel]")
  true
  """
  def is_a_real_room?(room) do
    room
    |> String.split("-")
    |> Enum.drop(-1)
    # |> Enum.each( fn())

    |> Enum.join
    |> String.codepoints
    |> Enum.sort
    |> Enum.chunk_by(fn(x) -> x end)
    |> Enum.sort(&(length(&1) > length(&2)))
    |> Enum.sort( fn(x,y)->
      if length(x) === length(y) do
        IO.inspect x
        Enum.at(x,0) < Enum.at(y,0)
      else
        true
      end
    end)
    |> Enum.take(5)
    |> Enum.map( fn(list)->
      list |> Enum.at 0
    end)
    |> Enum.join
    # sort by key
    # Enum.sort(&( elem(&1,0) > elem(&2, 0)))
    #sort by val
    # Enum.sort(&( elem(&1,1) > elem(&2, 1)))

  end

end
