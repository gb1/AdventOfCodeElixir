defmodule Aoc.Aoc2016.Day2 do


  @doc ~S"""
  Read file and find result

  iex>Aoc.Aoc2016.Day2.read_file_and_find_result
  ["7", "3", "5", "9", "7"]
  """
  def read_file_and_find_result do
    {:ok, file} = File.read("./lib/Aoc2016/day2.txt")
    file |> go
  end

  @doc ~S"""
  Read file and find result

  iex>Aoc.Aoc2016.Day2.read_file_and_find_result_part2
  ["A", "4", "7", "D", "A"]
  """
  def read_file_and_find_result_part2 do
    {:ok, file} = File.read("./lib/Aoc2016/day2.txt")
    file |> go_part_2
  end

  @doc ~S"""
  Solve the combination lock for the given input (part2)
  ##Tests

  iex>Aoc.Aoc2016.Day2.go("ULL\nRRDDD\nLURDL\nUUUUD")
  ["1","9","8","5"]
  """
  def go(input) do

    input
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.reduce("5", fn(line, code)->
      digit = line
      |> String.codepoints
      |> Enum.reduce(code, fn(instruction, result)->
        {last_digit, _} = result |> String.codepoints |> List.last |> Integer.parse
        last_digit |> Integer.to_string
        case instruction do
            "U" ->
              case last_digit do
                1 -> last_digit
                2 -> last_digit
                3 -> last_digit
                _ -> last_digit - 3
              end
            "D" ->
              case last_digit do
                7 -> last_digit
                8 -> last_digit
                9 -> last_digit
                _ -> last_digit + 3
              end
            "L" ->
              case last_digit do
                1 -> last_digit
                4 -> last_digit
                7 -> last_digit
                _ -> last_digit - 1
              end

            "R" ->
              case last_digit do
                3 -> last_digit
                6 -> last_digit
                9 -> last_digit
                _ -> last_digit + 1
              end
            end |> Integer.to_string
      end)
      code <> digit
    end)
    |> String.codepoints |> Enum.drop(1)
  end

  @doc ~S"""
  Solve the combination lock for the given input, part 2
  ##Tests

  iex>Aoc.Aoc2016.Day2.go_part_2("ULL\nRRDDD\nLURDL\nUUUUD")
  ["5", "D", "B", "3"]
  """

  def go_part_2(input) do
    input
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.reduce("5", fn(line, code)->
      digit = line
      |> String.codepoints
      |> Enum.reduce(code, fn(instruction, result)->
        last_digit = result |> String.codepoints |> List.last

        move(last_digit, instruction)

      end)
      # IO.puts digit
      code <> digit
    end)
    |> String.codepoints |> Enum.drop(1)
  end


  @doc ~S"""
  Make a move for part 2
  ##Tests

  iex>Aoc.Aoc2016.Day2.move("1", "D")
  "3"
  """
  def move(position, direction) do
    # IO.puts position
    # IO.puts direction
    case direction do
      "D" ->
        case position do
          "1" -> "3"
          "2" -> "6"
          "3" -> "7"
          "4" -> "8"
          "5" -> "5"
          "6" -> "A"
          "7" -> "B"
          "8" -> "C"
          "9" -> "9"
          "A" -> "A"
          "B" -> "D"
          "C" -> "C"
          "D" -> "D"
        end
      "U" ->
        case position do
          "1" -> "1"
          "2" -> "2"
          "3" -> "1"
          "4" -> "4"
          "5" -> "5"
          "6" -> "2"
          "7" -> "3"
          "8" -> "4"
          "9" -> "9"
          "A" -> "6"
          "B" -> "7"
          "C" -> "8"
          "D" -> "B"
        end
        "L" ->
          case position do
            "1" -> "1"
            "2" -> "2"
            "3" -> "2"
            "4" -> "3"
            "5" -> "5"
            "6" -> "5"
            "7" -> "6"
            "8" -> "7"
            "9" -> "8"
            "A" -> "A"
            "B" -> "A"
            "C" -> "B"
            "D" -> "D"
          end
          "R" ->
            case position do
              "1" -> "1"
              "2" -> "3"
              "3" -> "4"
              "4" -> "4"
              "5" -> "6"
              "6" -> "7"
              "7" -> "8"
              "8" -> "9"
              "9" -> "9"
              "A" -> "B"
              "B" -> "C"
              "C" -> "C"
              "D" -> "D"
            end
    end

  end
end
