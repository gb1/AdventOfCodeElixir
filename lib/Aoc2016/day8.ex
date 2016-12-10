defmodule Aoc.Aoc2016.Day8 do

  @doc """
  iex>Aoc.Aoc2016.Day8.part1
  128
  """
  def part1 do
    tcds = build_tcds(50,6,6,[])

    {:ok, file} = File.read("./lib/Aoc2016/day8.txt")

    instructions = file
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.map( fn(line)->
      case line do
        "rect" <> rest ->
          {:rect, rest |> extract_ints}
        "rotate row" <> rest ->
          {:row, rest |> extract_ints}
        "rotate column" <> rest ->
          {:col, rest |> extract_ints}
      end
    end)

    tcds = execute_instructions(instructions, tcds)

    tcds
    |> Matrix.rows
    |> Enum.each(fn(row)->
      row
      |> Vector.to_list
      |> List.flatten
      |> Enum.join
      |> IO.inspect
    end)

    tcds
    |> Matrix.rows
    |> Enum.reduce(0, fn(row, acc)->
      count  = row
      |> Vector.to_list
      |> List.flatten
      |> Enum.count( &(&1 === "🎅"))
      |> IO.inspect

      acc + count
    end)
  end

  def execute_instructions([], tcds), do: tcds
  def execute_instructions(instructions, tcds) do
    instruction = instructions |> List.first

    [x,y] = instruction |> elem(1)

    tcds =
    case instruction |> elem(0) do
      :rect -> create_rectangle(x, y, tcds)
      :col -> rotate_col(x, y, tcds)
      :row -> rotate_row(x, y, tcds)
    end
    # IO.inspect tcds

    execute_instructions(instructions |> Enum.drop(1), tcds)
  end

  @doc """
  Extract two integers from a string

  iex>Aoc.Aoc2016.Day8.extract_ints(" x=11 by 5")
  [11,5]

  iex>Aoc.Aoc2016.Day8.extract_ints(" y=0 by 7")
  [0,7]

  """
  def extract_ints(string) do
    string
    |> (&Regex.scan(~r/[0-9]+/, &1)).()
    |> List.flatten
    |> Enum.map(&(&1 |> Integer.parse) |> elem(0))
  end


  @doc """
  iex>Aoc.Aoc2016.Day8.build_tcds(7,3,3,[])
  Matrix.new([["🎄","🎄","🎄","🎄","🎄","🎄","🎄"],
   ["🎄","🎄","🎄","🎄","🎄","🎄","🎄"],
   ["🎄","🎄","🎄","🎄","🎄","🎄","🎄"]],3,7)
  """
  def build_tcds(x,y,0,tcds) do
    tcds |> Matrix.new(y,x)
  end
  def build_tcds(x,y,count,tcds) do
    tcds = tcds |> List.insert_at(0, build_row(x, []))
    build_tcds(x,y,count-1,tcds)
  end

  @doc """
  iexAoc.Aoc2016.Day8.build_row(7,[])
  ["🎄","🎄","🎄","🎄","🎄","🎄","🎄"]
  """
  def build_row(0, row), do: row
  def build_row(x, row) do
    build_row(x-1,row |> List.insert_at(0, "🎄"))
  end


  def display_tcds(tcds) do
    tcds |> Matrix.rows
  end

  @doc """
  Create a x,y rectangle starting in the top left corner

  iex>Aoc.Aoc2016.Day8.create_rectangle(3,2, Aoc.Aoc2016.Day8.build_tcds(7,3,3,[]))
  Matrix.new([["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
   ["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
   ["🎄","🎄","🎄","🎄","🎄","🎄","🎄"]],3,7)
  """
  def create_rectangle(end_x, end_y,tcds) do
     for x <- 0..end_x - 1 do
       for y <- 0..end_y - 1 do
         {x,y}
       end
     end
     |> List.flatten
     |> put_into_tcds(tcds)
  end

  def put_into_tcds([], tcds), do: tcds
  def put_into_tcds([coord | tail], tcds) do
    tcds = put_in tcds[elem(coord, 1)][elem(coord, 0)], "🎅"
    put_into_tcds(tail, tcds)
  end

  def rotate_row(row, rotations, tcds) do
    rotated_vector = tcds
    |> Matrix.row(row)
    |> Vector.to_list
    |> rotate_a_list(rotations)

    tcds
    |> Matrix.rows
    |> List.replace_at(row, rotated_vector |> Vector.from_list)
    |> Matrix.from_rows
    # row = tcds |> Enum.at(update_row) |> Vector.to_list
    # row = row |> List.replace_at(col, new_values |> Enum.at(update_row))
    # rows = rows |> List.replace_at(update_row, row |> Vector.from_list)

    # IO.inspect

  end

  def rotate_col(col, rotations, tcds) do
    rotated_vector = tcds
    |> Matrix.column(col)
    |> Vector.to_list
    |> rotate_a_list(rotations)

    tcds
    |> Matrix.rows
    |> update_rows(col, rotated_vector, length(rotated_vector))
    |> Matrix.from_rows

  end
  def update_rows(rows, col, new_values, 0), do: rows
  def update_rows(rows, col, new_values, count) do
    update_row = length(new_values) - count

    row = rows |> Enum.at(update_row) |> Vector.to_list
    row = row |> List.replace_at(col, new_values |> Enum.at(update_row))
    rows = rows |> List.replace_at(update_row, row |> Vector.from_list)

    update_rows(rows, col, new_values, count - 1)
  end

  @doc """
  iex>Aoc.Aoc2016.Day8.rotate_a_list(["🎅","🎅","🎄"], 1)
  ["🎄","🎅","🎅"]
  iex>Aoc.Aoc2016.Day8.rotate_a_list(["🎄","🎅","🎅"], 1)
  ["🎅","🎄","🎅"]
  iex>Aoc.Aoc2016.Day8.rotate_a_list(["🎅","🎅","🎄"], 2)
  ["🎅","🎄","🎅"]
  """
  def rotate_a_list(list,0), do: list
  def rotate_a_list(list, rotations) do
    rotate_a_list([(list |> List.last)] ++ (list |> Enum.drop(-1)), rotations - 1)
  end
end

ExUnit.start(exclude: [:skip])

defmodule Aoc.Aoc2016.Day8Test do
  use ExUnit.Case, async: true

  @tag :skip
  test "test the col rotation" do

    input = Matrix.new([["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
                        ["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
                        ["🎄","🎄","🎄","🎄","🎄","🎄","🎄"]],3,7)
    output = Matrix.new([["🎅","🎄","🎅","🎄","🎄","🎄","🎄"],
                         ["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
                         ["🎄","🎅","🎄","🎄","🎄","🎄","🎄"]],3,7)

    assert Aoc.Aoc2016.Day8.rotate_col(1, 1, input) === output
  end

  @tag :skip
  test "test the row rotation" do

    input = Matrix.new([["🎅","🎄","🎅","🎄","🎄","🎄","🎄"],
                         ["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
                         ["🎄","🎅","🎄","🎄","🎄","🎄","🎄"]],3,7)
    output = Matrix.new([["🎄","🎄","🎄","🎄","🎅","🎄","🎅"],
                         ["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
                         ["🎄","🎅","🎄","🎄","🎄","🎄","🎄"]],3,7)

    assert Aoc.Aoc2016.Day8.rotate_row(0, 4, input) === output
  end

end
