defmodule Aoc.Aoc2016.Day13 do

  def build_maze(fav_number) do

    for y <- 0..50 do
      for x <- 0..50 do
        case (x*x + 3*x + 2*x*y + y + y*y) + fav_number
        |> Integer.to_string(2) #convert to binary
        |> String.split("")
        |> Enum.filter(&(&1 === "1"))
        |> length
        |> rem(2) do
          0 -> {x,y," "}
          1 -> {x,y,"█"}
        end
      end
    end
  end

  def print_maze(maze) do
    maze
    |> Enum.each(fn(line)->
      line
      |> Enum.reduce("", fn(coord, acc)->
        acc <> elem(coord, 2)
      end)
      |> IO.puts
    end)
  end

end

ExUnit.start(exclude: [:skip])
# ExUnit.configure(timeout: :infinity)

defmodule Aoc.Aoc2016.Day13Test do
  use ExUnit.Case, async: true

  @tag :skip
  test "build maze for test data" do
    maze = Aoc.Aoc2016.Day13.build_maze(10)

    Aoc.Aoc2016.Day13.print_maze maze

    assert maze |> Enum.at(0) |> Enum.at(0) === {0,0,"."}
    assert maze |> Enum.at(0) |> Enum.at(9) === {0,9,"#"}
    assert maze |> Enum.at(0) |> Enum.at(2) === {0,2,"."}

  end

  test "solve part 1" do
    maze = Aoc.Aoc2016.Day13.build_maze(1364)

    Aoc.Aoc2016.Day13.print_maze maze

    # assert maze |> Enum.at(0) |> Enum.at(0) === {0,0,"."}
    # assert maze |> Enum.at(0) |> Enum.at(9) === {0,9,"#"}
    # assert maze |> Enum.at(0) |> Enum.at(2) === {0,2,"."}

  end


end
