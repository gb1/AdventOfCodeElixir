defmodule Aoc.Aoc2015.Day17 do

  @doc """
  iex>Aoc.Aoc2015.Day17.create_combinations
  654
  """
  def create_combinations do

    input = [50,44,11,49,42,46,18,32,26,40,21,7,18,43,10,47,36,24,22,40]

    combos = for n <- 3..15 do
      ok = input |> Combination.combine(n)
      |> Enum.filter(fn(list) ->
        list |> Enum.sum == 150
      end)
      |> length
    end

    Enum.sum combos
  end

end
