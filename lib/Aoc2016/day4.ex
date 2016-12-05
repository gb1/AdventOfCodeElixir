defmodule Aoc.Aoc2016.Day4 do

  @doc ~S"""
  Parse input file and return the sum of the sector ids

  iex>Aoc.Aoc2016.Day4.solve_part_1
  33
  """
  def solve_part_1 do
    {:ok, file} = File.read("./lib/Aoc2016/day4.txt")

    file
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.filter( fn(line)->
      line |> is_a_real_room?
    end)
    |> Enum.reduce(0, fn(room, total)->
      {sector_id, _} = room |> String.split("-")
      |> List.last
      |> String.split("[")
      |> List.first
      |> Integer.parse
      # IO.inspect total/
      # IO.inspect sector_id
      total + sector_id
    end)
  end

  @doc ~S"""
  Detect real rooms, checksum equals the first 5 most common letters

  ##Tests
  iex>Aoc.Aoc2016.Day4.is_a_real_room?("aaaaa-bbb-z-y-x-123[abxyz]")
  true
  iex>Aoc.Aoc2016.Day4.is_a_real_room?("not-a-real-room-404[oarel]")
  true
  iex>Aoc.Aoc2016.Day4.is_a_real_room?("a-b-c-d-e-f-g-h-987[abcde]")
  true
  iex>Aoc.Aoc2016.Day4.is_a_real_room?("totally-real-room-200[decoy]")
  false
  iex>Aoc.Aoc2016.Day4.is_a_real_room?("hcd-gsqfsh-wbhsfbohwcboz-pibbm-aofyshwbu-532[bhsfo]")
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
    |> Enum.chunk_by(fn(x) -> length x end)
    |> Enum.map( fn(chunk)->
      chunk |> Enum.sort
    end)
    |> List.flatten
    |> Enum.uniq
    |> Enum.take(5)
    |> Enum.join
    # |> Enum.sort( fn(x,y)->
    #
    #   if length(x) === length(y) do
    #     # IO.inspect x
    #     Enum.at(x,0) < Enum.at(y,0)
    #   end
    # end)
    # |> Enum.take(5)
    # |> Enum.map( fn(list)->
    #   list |> Enum.at(0)
    # end)
    # |> Enum.join
    # sort by key
    # Enum.sort(&( elem(&1,0) > elem(&2, 0)))
    #sort by val
    # Enum.sort(&( elem(&1,1) > elem(&2, 1)))
    ===
    room
    |> String.split("-")
    |> List.last
    |> (&Regex.named_captures(~r/\[(?<check_sum>.*)\]/, &1)["check_sum"]).()

  end

end
