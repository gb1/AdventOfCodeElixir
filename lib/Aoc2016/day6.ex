defmodule Aoc.Aoc2016.Day6 do

  def read_file do
    {:ok, file} = File.read("./lib/Aoc2016/day6.txt")
    file
  end

  def part1(input) do

    input
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.map( &(String.codepoints(&1)))
    |> List.zip
    |> Enum.map(fn x->
      Tuple.to_list(x)
    end)
    |> Enum.map( &(Enum.sort(&1)))
    |> Enum.map( fn(line)->
      line |> Enum.chunk_by(fn(x)->
        x
      end)
    end)
    |> Enum.map( fn(x)->
      x |> Enum.sort(&(length(&1) > length(&2)))
    end )
    |> Enum.map( fn(x)->
      Enum.at(x,0) |> Enum.at(0)
    end)
    |> Enum.join

  end


  def part2(input) do

    input
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.map( &(String.codepoints(&1)))
    |> List.zip
    |> Enum.map(fn x->
      Tuple.to_list(x)
    end)
    |> Enum.map( &(Enum.sort(&1)))
    |> Enum.map( fn(line)->
      line |> Enum.chunk_by(fn(x)->
        x
      end)
    end)
    |> Enum.map( fn(x)->
      x |> Enum.sort(&(length(&1) < length(&2)))
    end )
    |> Enum.map( fn(x)->
      Enum.at(x,0) |> Enum.at(0)
    end)
    |> Enum.join
  end

end


ExUnit.start(exclude: [:skip])

defmodule Aoc.Aoc2016.Day6Test do
  use ExUnit.Case, async: true

  # @tag :skip
  test "test the sample input" do
    # sample_input = "abc\nxyz\n123"
    sample_input = "eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar"
    assert Aoc.Aoc2016.Day6.part1(sample_input) === "easter"
  end

  test "test the file input for part 1" do
    {:ok, sample_input} = File.read("./lib/Aoc2016/day6.txt")
    assert Aoc.Aoc2016.Day6.part1(sample_input) === "mshjnduc"
  end

  test "test the sample input for part 2" do
    sample_input = "eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar"
    assert Aoc.Aoc2016.Day6.part2(sample_input) === "advent"
  end

  test "test the file input for part 2" do
    {:ok, sample_input} = File.read("./lib/Aoc2016/day6.txt")
    assert Aoc.Aoc2016.Day6.part2(sample_input) === "apfeeebz"
  end

end
