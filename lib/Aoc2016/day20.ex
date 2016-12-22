defmodule Aoc.Aoc2016.Day20 do

  def part1 do
    list = parse_file
    candidates = list |> generate_candidates
    ranges = list |> generate_ranges

    candidates
    |> Enum.filter(&(is_valid_candidate?(&1, ranges)))
    |> Enum.sort
  end

  def part2 do
    list = parse_file

    ranges = list |> generate_ranges |> Enum.sort

    starts = list
    |> Enum.map( fn(row)->
      {start, _} = row
      |> Enum.at(0)
      |> Integer.parse
      start
    end)
    |> Enum.sort

    #every candiate to the next start time

    candidates = list
    |> generate_candidates
    |> Enum.filter(&(is_valid_candidate?(&1, ranges)))
    |> Enum.sort

    candidates
    |> Enum.reduce(0, fn(candidate, acc)->
      case starts |> Enum.filter(&(&1 >= candidate)) do
        [] -> acc
        list -> acc + ( (list |> hd) - candidate )
      end
    end)
  end

  def parse_file do
    {:ok, file} = File.read("./lib/Aoc2016/day20.txt")

    list = file
    |> String.split("\n")
    |> Enum.filter(&(&1 !== ""))
    |> Enum.map(fn(row)->
      row
      |> String.split("-")
    end)
  end

  def generate_ranges(list) do
    list
    |> Enum.map( fn(row)->
      {range_start, _} = row
      |> Enum.at(0)
      |> Integer.parse

      {range_end, _} = row
      |> Enum.at(1)
      |> Integer.parse

      range_start..range_end
    end)
  end

  #take the ending number and add 1 to get a possible candiate
  def generate_candidates(list) do
    list
    |> Enum.map( fn(row)->
      {candidate, _} = row
      |> Enum.at(1)
      |> Integer.parse
      candidate + 1
    end)
    |> Enum.sort

  end

  def is_valid_candidate?(candidate, ranges) do
    ranges
    |> Enum.reduce_while(true, fn(range, acc)->
      case candidate in range do
        true-> {:halt, false}
        false->{:cont, true}
      end
    end)
  end

end

ExUnit.start(exclude: [:skip])
ExUnit.configure(timeout: :infinity)

defmodule Aoc.Aoc2016.Day20Test do
  use ExUnit.Case, async: true
  import Aoc.Aoc2016.Day20

  test "is a candidate valid?" do
    assert is_valid_candidate?(1, [5..8, 0..2, 4..7]) == false
    assert is_valid_candidate?(3, [5..8, 0..2, 4..7]) == true
  end

  test "generate a list of ranges from the input" do
    assert generate_ranges([["0", "20"],["20", "30"]]) == [0..20, 20..30]
  end

  # @tag :skip
  test "solve part 1" do
    assert part1 |> List.first === 14975795
  end

  test "solve part 2" do
    assert part2 === 101
  end

end
