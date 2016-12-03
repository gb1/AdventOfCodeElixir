defmodule Aoc.Aoc2016.Day3 do

  @doc ~S"""
  Squares With Three Sides

  ##Tests
  iex>Aoc.Aoc2016.Day3.go
  982
  """
  def go do
    {:ok, file} = File.read("./lib/Aoc2016/day3.txt")

    file
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.map( fn(line)->
      line
      |> String.trim
      |> String.split()
      |> Enum.map( fn(value)->
        {int_val,_} = value |> Integer.parse
        int_val
      end)
      |> Enum.sort
      |> Enum.reverse
    end)
    |> Enum.filter( fn(triangle)->
      [head | tail] = triangle
      head < tail |> Enum.sum
    end)
    |> length

  end


  @doc ~S"""
  Squares With Three Sides

  ##Tests
  iex>Aoc.Aoc2016.Day3.go_part_2
  1826
  """
  def go_part_2 do
    {:ok, file} = File.read("./lib/Aoc2016/day3.txt")

    file
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.map( fn(line)->
      line
      |> String.trim
      |> String.split()
      |> Enum.map( fn(value)->
        {int_val,_} = value |> Integer.parse
        int_val
      end)
    end)
    |> Enum.chunk(3)
    |> Enum.map( fn(chunk)->
      [[Enum.at(chunk, 0) |> Enum.at(0), Enum.at(chunk, 1) |> Enum.at(0), Enum.at(chunk, 2) |> Enum.at(0)],
      [Enum.at(chunk, 0) |> Enum.at(1), Enum.at(chunk, 1) |> Enum.at(1), Enum.at(chunk, 2) |> Enum.at(1)],
      [Enum.at(chunk, 0) |> Enum.at(2), Enum.at(chunk, 1) |> Enum.at(2), Enum.at(chunk, 2) |> Enum.at(2)]]
    end)
    |> List.flatten
    |> Enum.chunk(3)
    |> Enum.map( fn(line)->
      line |> Enum.sort |> Enum.reverse
    end)
    |> Enum.filter( fn(triangle)->
      [head | tail] = triangle
      head < tail |> Enum.sum
    end)
    |> length
  end
end
