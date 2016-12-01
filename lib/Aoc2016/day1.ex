defmodule Aoc.Aoc2016.Day1 do

  @doc ~S"""
  Follow the directions to the easter bunnys house!

  ##Examples
  niex>Aoc.Aoc2016.Day1.go("R2, L3")
  {"N", {2, 3}}

  niex>Aoc.Aoc2016.Day1.go("R2, R2, R2")
  {"W", {0, -2}}

  niex>Aoc.Aoc2016.Day1.go("R5, L5, R5, R3")
  {"S", {10, 2}}

  niex>Aoc.Aoc2016.Day1.go("R8, R4, R4, R8")
  {"N", {4, 4}}

  niex>Aoc.Aoc2016.Day1.go("R1, R1, R1, R1, L1, L1, L1, L1")
  {"N", {0, 0}}

  iex>Aoc.Aoc2016.Day1.go("R2, L1, R2, R1, R1, L3, R3, L5, L5, L2, L1, R4, R1, R3, L5, L5, R3, L4, L4, R5, R4, R3, L1, L2, R5, R4, L2, R1, R4, R4, L2, L1, L1, R190, R3, L4, R52, R5, R3, L5, R3, R2, R1, L5, L5, L4, R2, L3, R3, L1, L3, R5, L3, L4, R3, R77, R3, L2, R189, R4, R2, L2, R2, L1, R5, R4, R4, R2, L2, L2, L5, L1, R1, R2, L3, L4, L5, R1, L1, L2, L2, R2, L3, R3, L4, L1, L5, L4, L4, R3, R5, L2, R4, R5, R3, L2, L2, L4, L2, R2, L5, L4, R3, R1, L2, R2, R4, L1, L4, L4, L2, R2, L4, L1, L1, R4, L1, L3, L2, L2, L5, R5, R2, R5, L1, L5, R2, R4, R4, L2, R5, L5, R5, R5, L4, R2, R1, R1, R3, L3, L3, L4, L3, L2, L2, L2, R2, L1, L3, R2, R5, R5, L4, R3, L3, L4, R2, L5, R5")
  {"E", {147, -87}}
  """
  def go(input) do

    #set up an agent to hold state for the visited postions
    Agent.start_link(fn -> [] end, name: :locations)

    input |> String.split(", ")
    |> Enum.reduce({"N", {0,0}}, fn(x, acc)->

      case acc do
        {"N", _} -> north_move(acc, x)
        {"S", _} -> south_move(acc, x)
        {"E", _} -> east_move(acc, x)
        {"W", _} -> west_move(acc, x)
      end
    end)
  end

  def north_move(current_pos, move) do
    {_, {x, y}} = current_pos
    [direction | moves] = move |> String.codepoints
    {moves, _} = moves |> Enum.join |> Integer.parse
    case direction do
      "R" ->
        track_locations({x, y}, {x + moves, y}, :X)
        current_pos = {"E", {x + moves, y}}
      "L" ->
        track_locations({x, y}, {x - moves, y}, :X)
        current_pos = {"W", {x - moves, y}}
    end
  end

  def south_move(current_pos, move) do
    {_, {x, y}} = current_pos
    [direction | moves] = move |> String.codepoints
    {moves, _} = moves |> Enum.join |> Integer.parse
    case direction do
      "R" ->
        track_locations({x, y}, {x - moves, y}, :X)
        current_pos = {"W", {x - moves, y}}
      "L" ->
        track_locations({x, y}, {x + moves, y}, :X)
        current_pos = {"E", {x + moves, y}}
    end
  end

  def east_move(current_pos, move) do
    {_, {x, y}} = current_pos
    [direction | moves] = move |> String.codepoints
    {moves, _} = moves |> Enum.join |> Integer.parse
    case direction do
      "R" ->
        track_locations({x, y}, {x, y - moves}, :Y)
        current_pos = {"S", {x, y - moves}}
      "L" ->
        track_locations({x, y}, {x, y + moves}, :Y)
        current_pos = {"N", {x, y + moves}}
    end
  end

  def west_move(current_pos, move) do
    {_, {x, y}} = current_pos
    [direction | moves] = move |> String.codepoints
    {moves, _} = moves |> Enum.join |> Integer.parse
    case direction do
      "R" ->
        track_locations({x, y}, {x, y + moves}, :Y)
        current_pos = {"N", {x, y + moves}}
      "L" ->
        track_locations({x, y}, {x, y - moves}, :Y)
        current_pos = {"S", {x, y - moves}}
    end
  end

  @doc """
  Log every visited positon so we can find where we have been before
  """
  def track_locations(starting_position, end_position, axis) do
    {start_x, start_y} = starting_position
    {end_x, end_y} = end_position

    case axis do
      :X ->
        start_x..end_x
        |> Enum.drop(1)
        |> Enum.each( fn(x) ->
          check_for_duplicate({x, start_y})
          Agent.update(:locations, fn(list) ->
            list |> List.insert_at(Enum.count(list), {x, start_y})
          end)
        end)
      :Y ->
        start_y..end_y
        |> Enum.drop(1)
        |> Enum.each( fn(y) ->
          check_for_duplicate({start_x, y})
          Agent.update(:locations, fn(list) ->
            list |> List.insert_at(Enum.count(list), {start_x, y})
          end)
        end)
    end
  end

  def check_for_duplicate(position) do
    Agent.get(:locations, fn(list) ->
      list |> Enum.each(fn(pos) ->
        if pos === position do
          IO.puts "hohohohohoho"
           IO.inspect position
        end
      end)
    end)
  end

end
