# defmodule Aoc.Aoc2016.Day15 do
#
#   def get_position(positions, current, seconds) do
#     Stream.cycle(0..positions - 1) |> Enum.at(current + seconds)
#     end
#
#   def fast_forward(discs, 0), do: discs
#   def fast_forward(discs, seconds) do
#     fast_forward(discs |> tick, seconds - 1)
#   end
#
#   def drop_capsule([]), do: true
#
#   def drop_capsule(discs) do
#     discs |> List.last |> IO.inspect
#      #can we get through the top disc in 1 seconds time?
#     disc = discs |> tick |> Enum.at(0)
#     case get_position(disc.positions, disc.position) do
#       0 -> drop_capsule(discs |> Enum.drop(1) |> tick)
#       _ -> false
#     end
#   end
#
#   def create_discs do
#      [%{:disc => 1, :positions => 5, :position => 4 },
#       %{:disc => 2, :positions => 2, :position => 1 }]
#   end
#
#   # Disc #1 has 13 positions; at time=0, it is at position 11.
#   # Disc #2 has 5 positions; at time=0, it is at position 0.
#   # Disc #3 has 17 positions; at time=0, it is at position 11.
#   # Disc #4 has 3 positions; at time=0, it is at position 0.
#   # Disc #5 has 7 positions; at time=0, it is at position 2.
#   # Disc #6 has 19 positions; at time=0, it is at position 17.
#   def create_part1_discs do
#     [%{:disc => 1, :positions => 13, :position => 11 },
#      %{:disc => 2, :positions => 5, :position => 0 },
#      %{:disc => 3, :positions => 17, :position => 11 },
#      %{:disc => 4, :positions => 3, :position => 0 },
#      %{:disc => 5, :positions => 7, :position => 2 },
#      %{:disc => 6, :positions => 19, :position => 17 }]
#   end
#
#   def tick(discs) do
#     discs = discs
#     |> Enum.map(fn(disc)->
#       disc |> Map.put(:position, get_position(disc.positions, disc.position) )
#     end)
#   end
#
#   def get_position(positions, current) do
#     Stream.cycle(0..positions - 1) |> Enum.at(current)
#   end
# end
#
# ExUnit.start(exclude: [:skip])
# ExUnit.configure(timeout: :infinity)
#
# defmodule Aoc.Aoc2016.Day15Test do
#   use ExUnit.Case, async: true
#   import Aoc.Aoc2016.Day15
#
#   @tag :skip
#   test "postion shift loops around" do
#     assert Aoc.Aoc2016.Day15.get_position(5, 4) === 0
#   end
#
#   @tag :skip
#   test "time tick updates the discs" do
#     assert tick(create_discs) ===
#       [%{:disc => 1, :positions => 5, :position => 0 },
#        %{:disc => 2, :positions => 2, :position => 0 }]
#   end
#
#   @tag :skip
#   test "fast forward 1 second form test data gets us to the required state" do
#
#     assert fast_forward(create_discs, 1) ===
#       [%{:disc => 1, :positions => 5, :position => 0 },
#        %{:disc => 2, :positions => 2, :position => 0 }]
#   end
#
#   @tag :skip
#   test "fast forward 2 seconds gets us to the required state (1 for both 5 and 2)" do
#     assert fast_forward(create_discs, 2) ===
#       [%{:disc => 1, :positions => 5, :position => 1 },
#        %{:disc => 2, :positions => 2, :position => 1 }]
#   end
#
#   @tag :skip
#   test "fast forward 5 seconds gets us to a valid state (4 and 0), capsule will hit in 1 second" do
#     assert fast_forward(create_discs, 5) ===
#       [%{:disc => 1, :positions => 5, :position => 4 },
#        %{:disc => 2, :positions => 2, :position => 0 }]
#   end
#
#   @tag :skip
#   test "dropping the capsule on a closed disc will fail" do
#     assert drop_capsule(create_discs |> fast_forward(1)) === false
#   end
#
#   @tag :skip
#   test "dropping the capsule on a valid state will pass" do
#     assert drop_capsule(create_discs |> fast_forward(5)) === true
#   end
#
#   @tag :skip
#   test "solve for the test data" do
#     # assert solve_for_test_data === 5
#   end
#
#   @tag :skip
#   test "solve for the part 1" do
#     assert solve_for_part_1 === 5
#   end
#
#   @tag :skip
#   test "brute force" do
#     assert blunt_instrument === 2
#   end
#
# end
