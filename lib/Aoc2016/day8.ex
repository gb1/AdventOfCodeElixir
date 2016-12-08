defmodule Aoc.Aoc2016.Day8 do

  @doc """
  iex>Aoc.Aoc2016.Day8.part1
  110
  """
  def part1 do
    tcds = build_tcds(50,6, [])

    {:ok, file} = File.read("./lib/Aoc2016/day8.txt")
    file
    |> String.split("\n")
    |> Enum.filter( fn(line)-> line !== "" end)
    |> Enum.map( fn(line)->
      case line do
        "rect" <> rest ->
          {:rect, rest}
        "rotate row" <> rest ->
          {:row, rest}
        "rotate column" <> rest ->
          {:col, rest}
      end
    end)
  end

  @doc """
  iex>Aoc.Aoc2016.Day8.build_tcds(7,3,[])
  Matrix.new([["🎄","🎄","🎄","🎄","🎄","🎄","🎄"],
   ["🎄","🎄","🎄","🎄","🎄","🎄","🎄"],
   ["🎄","🎄","🎄","🎄","🎄","🎄","🎄"]],3,7)
  """
  def build_tcds(_,0,tcds) do
    tcds |> Matrix.new(3,7)
  end
  def build_tcds(x,y,tcds) do

    tcds = tcds |> List.insert_at(0, build_row(x, []))
    # IO.inspect tcds
    build_tcds(x, y-1, tcds)
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

  iex>Aoc.Aoc2016.Day8.create_rectangle(3,2, Aoc.Aoc2016.Day8.build_tcds(7,3,[]))
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


    # IO.inspect tcds
    # tcds
    # |> Matrix.rows
    # |> Enum.map( fn(row)->
    #   IO.inspect row
    #   # |> Vector.to_list
    #   # |> List.replace_at(col, "A")
    #   # |> Vector.from_list
    # end)
    # |> Matrix.from_rows
    # |> IO.inspect
    # tcds
    # |> Matrix.columns
    #
    # |> List.replace_at(col, rotated_vector)
    # |> Matrix.from_rows
    # |> Matrix.rows
    # |> Enum.each(fn(row)->
    #   IO.inspect row
    # end)
    # |> Matrix.rotate_clockwise
    # |> Matrix.rotate_clockwise
    # |> Matrix.rotate_clockwise
    # |> IO.inspect

    # tcds
    # Matrix.from_rows

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

  # @tag :skip
  test "test the col rotation" do

    input = Matrix.new([["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
                        ["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
                        ["🎄","🎄","🎄","🎄","🎄","🎄","🎄"]],3,7)
    output = Matrix.new([["🎅","🎄","🎅","🎄","🎄","🎄","🎄"],
                         ["🎅","🎅","🎅","🎄","🎄","🎄","🎄"],
                         ["🎄","🎅","🎄","🎄","🎄","🎄","🎄"]],3,7)

    assert Aoc.Aoc2016.Day8.rotate_col(1, 1, input) === output
  end

  # @tag :skip
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
