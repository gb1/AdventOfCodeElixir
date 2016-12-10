defmodule Aoc.Aoc2016.Day9 do

  @doc """
  iex>Aoc.Aoc2016.Day9.part1
  :pass
  """
  def part1 do
    {:ok, file} = File.read("./lib/Aoc2016/day9.txt")

    keys = file
    |> (&Regex.scan(~r/[^\)]\([0-9]+x[0-9]+\)/U, &1)).()


    # #regex result ends up with the last letter of the "bits" at the start
    # #of the keys, get the letters and add to the bits
    missing_last_letters =
      keys
      |> Enum.map(fn(key)->
        key
        |> List.first
        |> String.codepoints
        |> List.first
      end)


    bits = file
    |> String.split(~r/[^\)]\([0-9]+x[0-9]+\)/U)

    last_bit = bits |> List.last |> String.replace("\n", "")
    bits = List.zip([bits, missing_last_letters])


    bits = bits
    |> Enum.map(fn(row)->
      elem(row, 0) <> elem(row, 1)
    end)

    bits = bits |> Enum.drop(1)
    bits = bits ++ [last_bit]


    keys
    #
    # keys = keys
    # |> Enum.map(fn(key)->
    #   key |> List.first |> extract_ints
    # end)
    # keys |> List.insert_at(0, [14,1])
    # #
    # # # add on a blank row to get things lined up
    # # # keys = keys |> List.insert_at(0, [])
    # # bits = bits |> Enum.drop(1)
    # #
    # List.zip([keys, bits])
    # |> Enum.map(fn(chunk)->
    #   decompress(elem(chunk,0), elem(chunk,1))
    # end)
    # # |> List.last
    # |> Enum.join
    # |> String.length

  end

  @doc """
  iex>Aoc.Aoc2016.Day9.extract_ints("H(7x13)")
  [7,13]
  """
  def extract_ints(string) do
    string
    |> (&Regex.scan(~r/[0-9]+/, &1)).()
    |> List.flatten
    |> Enum.map(&(&1 |> Integer.parse) |> elem(0))
  end

  @doc """
  iex>Aoc.Aoc2016.Day9.decompress([1,5], "BC")
  "BBBBBC"
  iex>Aoc.Aoc2016.Day9.decompress([3,3], "XYZ")
  "XYZXYZXYZ"
  iex>Aoc.Aoc2016.Day9.decompress([6,1], "(1x3)A")
  "(1x3)A"
  iex>Aoc.Aoc2016.Day9.decompress([4,12], "LAMTLYVGMJBGV")
  "LAMTLAMTLAMTLAMTLAMTLAMTLAMTLAMTLAMTLAMTLAMTLAMTLYVGMJBGV"
  """
  def decompress([], string), do: string
  def decompress([chars, repeat], string) do
    repeated = string
    |> String.codepoints
    |> Enum.take(chars)
    |> Enum.join
    |> repeat_string("", repeat)

    repeated <> (String.split_at(string, chars) |> elem(1))
  end

  def repeat_string(string, result, 0), do: result
  def repeat_string(string, result, count) do
     repeat_string(string, result <> string, count - 1)
  end
end
