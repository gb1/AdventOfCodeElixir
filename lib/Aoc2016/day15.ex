defmodule Aoc.Aoc2016.Day15 do

  def solve_for_test_data do
    0..100
    |> Enum.reduce_while(nil, fn(seconds_to_wait, acc)->
      case drop_capsule(create_discs |> fast_forward(seconds_to_wait)) do
        true -> {:halt, seconds_to_wait}
        false -> {:cont, nil}
      end
    end)
    |> IO.inspect

  end

  def fast_forward(discs, 0), do: discs
  def fast_forward(discs, seconds) do
    fast_forward(discs |> tick, seconds - 1)
  end

  def drop_capsule([]), do: true

  def drop_capsule(discs) do
     #can we get through the top disc in 1 seconds time?
    disc = discs |> tick |> Enum.at(0)
    case disc.position do
      0 -> drop_capsule(discs |> Enum.drop(1) |> tick)
      _ -> false
    end
  end

  def create_discs do
     [%{:disc => 1, :positions => 5, :position => 4 },
      %{:disc => 2, :positions => 2, :position => 1 }]
  end

  def tick(discs) do
    discs = discs
    |> Enum.map(fn(disc)->
      disc |> Map.put(:position, get_position(disc.positions, disc.position) )
    end)
  end

  def get_position(positions, current) do
    Stream.cycle(0..positions - 1) |> Enum.at(current + 1)
  end
end

ExUnit.start(exclude: [:skip])
# ExUnit.configure(timeout: :infinity)

defmodule Aoc.Aoc2016.Day15Test do
  use ExUnit.Case, async: true
  import Aoc.Aoc2016.Day15

  test "postion shift loops around" do
    assert Aoc.Aoc2016.Day15.get_position(5, 4) === 0
  end

  @tag :skip
  test "time tick updates the discs" do
    assert tick(create_discs) ===
      [%{:disc => 1, :positions => 5, :position => 0 },
       %{:disc => 2, :positions => 2, :position => 0 }]
  end

  @tag :skip
  test "fast forward 1 second form test data gets us to the required state" do

    assert fast_forward(create_discs, 1) ===
      [%{:disc => 1, :positions => 5, :position => 0 },
       %{:disc => 2, :positions => 2, :position => 0 }]
  end

  # @tag :skip
  test "fast forward 2 seconds gets us to the required state (1 for both 5 and 2)" do
    assert fast_forward(create_discs, 2) ===
      [%{:disc => 1, :positions => 5, :position => 1 },
       %{:disc => 2, :positions => 2, :position => 1 }]
  end

  # @tag :skip
  test "fast forward 5 seconds gets us to a valid state (4 and 0), capsule will hit in 1 second" do
    assert fast_forward(create_discs, 5) ===
      [%{:disc => 1, :positions => 5, :position => 4 },
       %{:disc => 2, :positions => 2, :position => 0 }]
  end

  test "dropping the capsule on a closed disc will fail" do
    assert drop_capsule(create_discs |> fast_forward(1)) === false
  end

  test "dropping the capsule on a valid state will pass" do
    assert drop_capsule(create_discs |> fast_forward(5)) === true
  end

  test "solve for the test data" do
    assert solve_for_test_data === 5
  end

end
