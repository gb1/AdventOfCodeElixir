defmodule Aoc.Aoc2016.Day5 do

#   def calc_password(_, password, _, 9) do
#     password |> String.downcase
#   end
#
#   def calc_password(door_id, password, current_int, length) do
#     if :crypto.hash(:md5, door_id <> Integer.to_string(current_int))
#     |> Base.encode16
#     |> String.codepoints
#     |> Enum.take(5)
#     |> Enum.join === "00000" do
#
#       password_char = :crypto.hash(:md5, door_id <> Integer.to_string(current_int))
#       |> Base.encode16
#       |> String.codepoints
#       |> Enum.at(5)
#
#       IO.puts password <> password_char
#       calc_password(door_id, password <> password_char, current_int + 1, length + 1)
#
#     else
#       calc_password(door_id, password, current_int + 1 , length)
#     end
#
#   end
#
#   def calc_password_part_2(_, password, _, 7) do
#     password |> String.downcase
#   end
#
#   def calc_password_part_2(door_id, password, current_int, found) do
#     # IO.puts "guessing..."
#     [password, current_int, found] = case :crypto.hash(:md5, door_id <> Integer.to_string(current_int))
#     |> Base.encode16
#     |> String.codepoints
#     |> Enum.take(5)
#     |> Enum.join do
#
#       "00000" ->
#
#       case :crypto.hash(:md5, door_id <> Integer.to_string(current_int))
#       |> Base.encode16
#       |> String.codepoints
#       |> Enum.drop(5)
#       |> Enum.take(2)
#       |> &(Integer.parse(&1)).() do
#         :error ->
#           [password, current_int, found]
#         {position, _} ->
#           IO.puts found
#           [password, current_int, found + 1]
#           # if position < 8 do
#           #   if Enum.at(password |> String.codepoints, position) === "_" do
#           #     password = password
#           #     |> String.codepoints
#           #     |> List.replace_at(position, password_char)
#           #     |> Enum.join
#           #     IO.puts password
#           #     [password, current_int + 1, found + 1]
#           #     # calc_password_part_2(door_id, password, current_int + 1, found + 1)
#           #   end
#           # end
#         end
#         _ -> [password, current_int, found]
#     end
#     calc_password_part_2(door_id, password, current_int + 1, found)
#   end
#
#
#
# end
#
#
# ExUnit.start(exclude: [:skip])
# ExUnit.configure(timeout: :infinity) #this might take a while
#
# defmodule Aoc.Aoc2016.Day5Test do
#   use ExUnit.Case, async: true
#
#   @tag :skip
#   test "crack the sample password" do
#     assert Aoc.Aoc2016.Day5.calc_password("abc", "", 0, 1) === "18f47a30"
#   end
#
#   @tag :skip
#   test "crack the problem 1 input ffykfhsq" do
#     assert Aoc.Aoc2016.Day5.calc_password("ffykfhsq", "", 0, 1) === "c6697b55"
#   end
#
#   @tag :skip
#   test "crack the sample for problem 2" do
#     assert Aoc.Aoc2016.Day5.calc_password_part_2("abc", "________", 0, 1) === "05ace8e3"
#   end
#   @tag :skip
#   test "crack the problem 2 input ffykfhsq" do
#     IO.puts "ok go"
#     assert Aoc.Aoc2016.Day5.calc_password_part_2("ffykfhsq", "________", 0, 1) === "wt"
#   end
end
