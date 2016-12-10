defmodule Aoc.Aoc2016.Day9 do

  @doc """
  iex>Aoc.Aoc2016.Day9.part1
  :pass
  """
  def part1 do
    {:ok, file} = File.read("./lib/Aoc2016/day9.txt")

    file
    |> String.codepoints
    |> String.replace("\n") #every time this gets me!
    |> decompress("")
    |> String.length
  end

  @doc """
  iex>"ADVENT" |> String.codepoints |> Aoc.Aoc2016.Day9.decompress("")
  "ADVENT"
  iex>"A(1x5)BC" |> String.codepoints |> Aoc.Aoc2016.Day9.decompress("")
  "ABBBBBC"
  iex>"A(2x2)BCD(2x2)EFG" |> String.codepoints |> Aoc.Aoc2016.Day9.decompress("")
  "ABCBCDEFEFG"
  """
  def decompress([], decompressed), do: decompressed

  def decompress(["(" | tail], decompressed) do
    marker = tail |> Enum.take_while(&(&1 != ")")) |> List.to_string
    [count, repeat] = extract_ints marker
    string_to_repeat = tail
    |> Enum.slice(String.length(marker)+1, count)
    |> List.to_string

    decompressed = decompressed <> repeat_string(string_to_repeat, "", repeat)
    decompress(tail |> Enum.drop(String.length(marker) + count + 1) , decompressed)
  end

  def decompress([head|tail], decompressed) do
    decompress(tail , decompressed <> head)
  end
  def decompress(list, decompressed) do
    list
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

  def repeat_string(string, result, 0), do: result
  def repeat_string(string, result, count) do
    repeat_string(string, result <> string, count - 1)
  end

end
