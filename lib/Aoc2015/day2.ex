defmodule Aoc.Aoc2015.Day2 do

  @doc """
  iex> Aoc.Aoc2015.Day2.calc_area([2,3,4])
  58
  iex> Aoc.Aoc2015.Day2.calc_area([1,1,10])
  43
  """
  def calc_area([l,w,h]) do
    ( 2*l*w + 2*w*h + 2*h*l ) +
    ( Enum.sort([l,w,h]) |> Enum.at(0) ) *
    (  Enum.sort([l,w,h]) |> Enum.at(1) )
  end

  @doc """
  iex> Aoc.Aoc2015.Day2.parse_string_to_dims("3x11x24")
  [3,11,24]
  """
  def parse_string_to_dims(input_string) do
    input_string
    |> String.split("x")
    |> Enum.map(fn(x) -> String.to_integer(x) end)
  end

  @doc """
  iex> Aoc.Aoc2015.Day2.calc_ribbon([2,3,4])
  34
  iex> Aoc.Aoc2015.Day2.calc_ribbon([1,1,10])
  14
  """
  def calc_ribbon([l,w,h]) do
    sorted = Enum.sort([l,w,h])
    (Enum.at(sorted, 0) * 2 ) +
    (Enum.at(sorted, 1) * 2 ) +
    (l * w * h)
  end

  @doc """
  iex> Aoc.Aoc2015.Day2.find_answer1
  1588178
  """
  def find_answer1 do
    File.read!("./lib/Aoc2015/day2_input.txt")
    |> String.trim
    |> String.split("\r\n")
    |> Enum.map(fn(x) -> parse_string_to_dims(x) end)
    |> Enum.reduce(0, fn(x, acc) -> acc = acc + calc_area(x) end)
  end

  @doc """
  iex> Aoc.Aoc2015.Day2.find_answer2
  3783758
  """
  def find_answer2 do
    File.read!("./lib/Aoc2015/day2_input.txt")
    |> String.trim
    |> String.split("\r\n")
    |> Enum.map(fn(x) -> parse_string_to_dims(x) end)
    |> Enum.reduce(0, fn(x, acc) -> acc = acc + calc_ribbon(x) end)
  end

end
