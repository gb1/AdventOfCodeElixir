defmodule Aoc.Aoc2015.Day1 do

  @doc """
    Find the floor
    ##Examples
    iex> Aoc.Aoc2015.Day1.find_floor( "(())" )
    0
    iex> Aoc.Aoc2015.Day1.find_floor( "(()(()(" )
    3
    iex> Aoc.Aoc2015.Day1.find_floor( ")())())" )
    -3
  """
  def find_floor(input_string) do

    input_string
    |> to_charlist
    |> Enum.reduce(0, fn(x, acc) ->
      case x do
         ?( -> acc = acc + 1
         ?) -> acc = acc - 1
       end
    end)
  end

  @doc """
  iex> Aoc.Aoc2015.Day1.steps_to_basement
  1795
  """
  def steps_to_basement() do
    File.read!("./lib/Aoc2015/day1_input.txt")
    |> String.trim
    |> to_charlist
    |> Enum.reduce({0,0}, fn(x, acc) ->

      case acc do
        {n, -1} -> n
        {n, p} ->
          case x do
            ?( -> {n + 1, p + 1 }
            ?) -> {n + 1, p - 1 }
          end
          n -> n
      end

    end)
  end

  @doc """
  iex> Aoc.Aoc2015.Day1.find_answers
  74
  """
  def find_answers do
    File.read!("./lib/Aoc2015/day1_input.txt")
    |> String.trim
    |> find_floor
  end

end
