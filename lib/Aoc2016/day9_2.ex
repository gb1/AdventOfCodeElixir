defmodule Aoc.Aoc2016.Day9_2 do

  @doc """
  iex>Aoc.Aoc2016.Day9_2.part1
  10
  """
  def part1 do
    {:ok, file} = File.read("./lib/Aoc2016/day9.txt")

    file
    |> String.codepoints
    |> String.replace("\n", "")
    |> decompress(0)
  end

  @doc """
  iex>"ADVENT" |> String.codepoints |> Aoc.Aoc2016.Day9_2.decompress(0)
  6
  """
  def decompress([], len), do: len

  def decompress(["(" | tail], len) do
    marker = tail |> Enum.take_while(&(&1 != ")")) |> List.to_string
    [count, repeat] = extract_ints marker
    data_length = tail
    |> Enum.drop(String.length(marker) + 1)
    |> Enum.take(count)
    |> decompress(0)

    decompress(
    tail |> Enum.drop(String.length(marker) + count + 1),
    data_length * repeat + len)
  end
  def decompressed_length(["\n" | tail], len), do: decompressed_length(tail, len)
  def decompress([head|tail], len) do
    decompress(tail , len + 1)
  end

  @doc """
  iex>Aoc.Aoc2016.Day9_2.extract_ints("H(7x13)")
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

# ExUnit.start(exclude: [:skip])
# ExUnit.configure(timeout: :infinity)
#
# defmodule Aoc.Aoc2016.Day9_2Test do
#   use ExUnit.Case, async: true
#
#   test "part 2" do
#
#     assert Aoc.Aoc2016.Day9_2.part2 === 123
#
#   end
# end
