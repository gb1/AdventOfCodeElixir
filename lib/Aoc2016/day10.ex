defmodule Aoc.Aoc2016.Day10 do

  @doc """
  iex>Aoc.Aoc2016.Day10.part1_and_2
  :pass
  """
  def part1_and_2 do
   {:ok, file} = File.read("./lib/Aoc2016/day10.txt")

    #create an Agent for each bot, store a low/high values and a list of instructions
    create_bots

    instructions = parse_input file

    populate_bot_data(instructions)

    list_bots
    |> Enum.each(fn(bot)->
      vals = Agent.get(bot, &Map.get(&1, :vals))
      case vals do
        [17,61] -> IO.puts "the part 1 answer is " <> Atom.to_string(bot)
        _ -> true
      end
    end)

    output0 = Agent.get(:output0, &Map.get(&1, :vals)) |> List.first
    output1 = Agent.get(:output1, &Map.get(&1, :vals)) |> List.first
    output2 = Agent.get(:output2, &Map.get(&1, :vals)) |> List.first


    IO.puts "the part 2 answer is " <> Integer.to_string((output0 * output1 * output2))
    :pass
  end

  def populate_bot_data(instructions) do

    instructions
    |> Enum.each(fn(instruction)->
      case length(instruction) do
        3-> add_instruction_to_bot(Enum.at(instruction,0), instruction)
        _-> true
      end
    end)

    instructions
    |> Enum.each(fn(instruction)->
      case length(instruction) do
        2-> add_value_to_bot(Enum.at(instruction,0), Enum.at(instruction,1))
        _-> true
      end
    end)
  end

  def bot_data(bot_name) do
    vals = Agent.get(bot_name, &Map.get(&1, :vals))
    instructions = Agent.get(bot_name, &Map.get(&1, :instructions))
    IO.inspect(vals, char_lists: false)
    IO.inspect(instructions, char_lists: false)
  end

  def list_bots do
    {:ok, file} = File.read("./lib/Aoc2016/day10.txt")
    file
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.reduce([], fn(line, acc)->
      case line do
        "value" <> rest ->
          [value, bot_no] = extract_ints line
          bot_name = "bot" <> (bot_no |> Integer.to_string) |> String.to_atom
          acc  ++ [bot_name]

        "bot" <> rest ->
          bot_name = "bot" <> (line |> String.split(" ") |> Enum.at(1)) |> String.to_atom
          low_target = (line |> String.split(" ") |> Enum.at(5)) <> (line |> String.split(" ") |> Enum.at(6))
          |> String.to_atom

          high_target = (line |> String.split(" ") |> Enum.at(10)) <> (line |> String.split(" ") |> Enum.at(11))
          |> String.to_atom
           acc ++ [bot_name, low_target, high_target]
      end
    end)
    |> Enum.sort
    |> Enum.uniq

  end

  def create_bots() do
    list_bots
    |> Enum.each(fn(bot_name)->
      create_bot bot_name
    end)
  end

  def parse_input(file) do
    file
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.map(fn(line)->
      case line do
        "value" <> rest ->
          [value, bot_no] = extract_ints line
          bot_name = "bot" <> (bot_no |> Integer.to_string) |> String.to_atom
          [bot_name, value]

        "bot" <> rest ->
          bot_name = "bot" <> (line |> String.split(" ") |> Enum.at(1)) |> String.to_atom
          low_target = (line |> String.split(" ") |> Enum.at(5)) <> (line |> String.split(" ") |> Enum.at(6))
          |> String.to_atom

          high_target = (line |> String.split(" ") |> Enum.at(10)) <> (line |> String.split(" ") |> Enum.at(11))
          |> String.to_atom

          [bot_name, low_target, high_target]
      end
    end)
  end

  def extract_ints(string) do
    string
    |> (&Regex.scan(~r/[0-9]+/, &1)).()
    |> List.flatten
    |> Enum.map(&(&1 |> Integer.parse) |> elem(0))
  end

  def create_bot(name) do
    Agent.start_link(fn -> %{:vals => [], :instructions => []} end, name: name)
  end

  def add_value_to_bot(bot_name, value) do
    Agent.update(bot_name, fn(bot_map)->
      vals = bot_map |> Map.get(:vals)
      vals = vals |> List.insert_at(0, value) |> Enum.sort
      # IO.puts Atom.to_string(bot_name)
      # IO.inspect vals, char_lists: false
      #if there are now two values then execute any instructions
      if length(vals) === 2 && !(Atom.to_string(bot_name) |> String.contains?("output")) do
        execute_instructions(Map.get(bot_map, :instructions), vals)
      end
      bot_map |> Map.put(:vals, vals)
    end)
  end

  def add_instruction_to_bot(bot_name, instruction) do
    Agent.update(bot_name, fn(bot_map)->
      instructions = bot_map |> Map.get(:instructions)
      bot_map |> Map.put(:instructions, instructions |> List.insert_at(-1, instruction))
    end)
  end

  def execute_instructions(instructions, vals) do
    # IO.inspect instructions
    # IO.inspect vals
    instructions
    |> Enum.each(fn(instruction)->
      add_value_to_bot(Enum.at(instruction, 1), Enum.at(vals, 0))
      add_value_to_bot(Enum.at(instruction, 2), Enum.at(vals, 1))
    end)


  end
end
