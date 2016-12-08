defmodule Aoc.Aoc2016.Day8 do

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

  @doc """
  Display the Tiny Code Displaying Screen

  iex>Aoc.Aoc2016.Day8.display_tcds
  []
  """
  def display_tcds do
    # build_tcds
    # |> Enum.each( fn(line)->
    #   IO.puts line |> List.to_string
    #   # IO.puts "\n"
    # end)
    []
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
  def put_into_tcds(coords, tcds) do
    [coord | tail] = coords
    tcds = put_in tcds[elem(coord, 1)][elem(coord, 0)], "🎅"
    put_into_tcds(tail, tcds)
  end

end
