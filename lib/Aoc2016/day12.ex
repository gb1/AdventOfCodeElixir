defmodule Aoc.Aoc2016.Day12 do

  @doc """
  iex>Aoc.Aoc2016.Day12.read_file
  100
  """
  def read_file do
    {:ok, file} = File.read("./lib/Aoc2016/day12.txt")
    file
    |> String.split("\n")
    |> Enum.filter(&(&1 !== ""))
    |> execute_instructions(%{:a => 0, :b => 0, :c => 1, :d =>0}, 0, false)
  end

  @doc """
  iex>Aoc.Aoc2016.Day12.execute_instructions(%{:a => 0, :b => 0, :c => 0, :d =>0},["cpy 41 a","inc a","inc a","dec a","jnz a 2","dec a"], 0, false)
  42
  """
  def execute_instructions(instructions, registers, position, true) do
    registers.a
  end
  def execute_instructions(instructions, registers, position, done) do

    instruction = instructions |> Enum.at(position)

    bits = instruction |> String.split(" ")

    [registers, position] = case instruction do
      "cpy" <> rest ->
        key = bits |> Enum.at(2) |> String.to_atom

        val = case Regex.match?(~r/^[0-9]*$/, bits |> Enum.at(1)) do
          true->
            {val, _} = bits |> Enum.at(1) |> Integer.parse
            val
          false->
            registers[bits |> Enum.at(1) |> String.to_atom]
          end
        [%{registers | key => val}, position + 1]

      "inc" <> rest ->
        key = bits |> Enum.at(1) |> String.to_atom
        val = registers[key]
        [%{registers | key => val + 1}, position + 1]
      "dec" <> rest ->
        key = bits |> Enum.at(1) |> String.to_atom
        val = registers[key]
        [%{registers | key => val - 1}, position + 1]
      "jnz" <> rest ->
        case registers[bits |> Enum.at(1) |> String.to_atom] do
          0-> [registers, position + 1]
          _->
          {jump, _} = bits |> Enum.at(2) |> Integer.parse
          [registers, position + jump]

        end
    end
    done = position >= instructions |> length
    execute_instructions(instructions, registers, position, done)
  end
end
