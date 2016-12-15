# defmodule Aoc.Aoc2016.Day140 do
#
#   @stretch 2016
#
#   def generate_keys(salt) do
#
#     Stream.unfold({0,0}, fn({nonce, new_state})->
#       {hash, nonce} = get_next_hash(salt, nonce)
#       # IO.inspect nonce
#       {nonce, {nonce + 1, 0}}
#     end)
#     |> Enum.take(1)
#     |> Enum.at(0)
#   end
#
#   def get_next_hash({hash, nonce}), do: {hash, nonce}
#   def get_next_hash(salt, nonce) do
#     # IO.inspect nonce
#     hash = hash(salt, nonce, @stretch)
#     IO.puts hash
#     if is_hash?(hash, salt, nonce) do
#       get_next_hash({hash, nonce})
#     else
#       get_next_hash(salt, nonce + 1)
#     end
#   end
#
#   def hash(hash, 0) do
#     IO.puts hash
#     hash
#   end
#
#   def hash(hash, stretch) do
#         IO.puts stretch
#         IO.puts "ok"
#     new_hash = case Agent.get(:cache, &Map.has_key?(&1, hash)) do
#       true->
#         IO.puts "found in cache"
#         # IO.inspect hash
#         Agent.get(:cache, &Map.get(&1, hash))
#       false->
#         new_hash = :crypto.hash(:md5, hash)
#         |> Base.encode16
#         |> String.downcase
#         Agent.update(:cache, &Map.put(&1, hash, new_hash))
#         new_hash
#     end
#     # IO.puts hash
#     hash(new_hash, stretch - 1)
#   end
#
#   def hash(salt, nonce, stretch) do
#
#     hash = case Agent.get(:cache, &Map.has_key?(&1, salt)) do
#       true->
#         # IO.puts "found in cache"
#         # IO.inspect salt
#         Agent.get(:cache, &Map.get(&1, salt))
#       false->
#         hash = :crypto.hash(:md5, salt)
#         |> Base.encode16
#         |> String.downcase
#         Agent.update(:cache, &Map.put(&1, salt, hash))
#         hash
#     end
#
#     case stretch do
#       0-> hash
#       _-> hash(hash, stretch)
#     end
#   end
#
#   def is_hash?(hash, salt, nonce) do
#     contains_triplet?(hash) #&& next_1000_contains_a_quintet?(salt, nonce, get_triplet(hash))
#   end
#
#   def contains_triplet?(hash) do
#     hash
#     |> String.split("")
#     |> Enum.chunk_by(&(&1))
#     |> Enum.any?(&(length(&1) >= 3))
#   end
#
#   def get_triplet(hash) do
#     hash
#     |> String.split("")
#     |> Enum.chunk_by(&(&1))
#     |> Enum.sort(&(length(&1) > length(&2)))
#     |> List.first
#     |> List.first
#   end
#
#   def contains_quintet?(hash,  char) do
#     hash
#     |> String.contains?(char <> char <> char <> char <> char)
#   end
#
#   def next_1000_contains_a_quintet?(salt, count, char) do
#       Enum.reduce_while(count + 1..count + 1000, false, fn(i, acc)->
#         if hash(salt, i, @stretch) |> contains_quintet?(char) do
#           {:halt, true}
#         else
#           {:cont, false}
#         end
#       end)
#   end
# end
#
# ExUnit.start(exclude: [:skip])
# ExUnit.configure(timeout: :infinity)
#
# defmodule Aoc.Aoc2016.Day140Test do
#   use ExUnit.Case, async: true
#
#   @tag :skip
#   test "contains triplet" do
#     assert Aoc.Aoc2016.Day14.contains_triplet?("cc38887a5") === true
#     assert Aoc.Aoc2016.Day14.contains_triplet?("cc38181817a5") === false
#   end
#
#   @tag :skip
#   test "get triplet character" do
#     assert Aoc.Aoc2016.Day14.get_triplet("cc38887a5") === "8"
#   end
#
#   @tag :skip
#   test "contains quintet" do
#     assert Aoc.Aoc2016.Day14.contains_quintet?("cc38887a5", "8") === false
#     assert Aoc.Aoc2016.Day14.hash("abc", 816, 0) |> Aoc.Aoc2016.Day14.contains_quintet?("e") === true
#   end
#
#   @tag :skip
#   test "contains quintet in the next 1000" do
#     assert Aoc.Aoc2016.Day14.next_1000_contains_a_quintet?("abc", 18, "8") === false
#     assert Aoc.Aoc2016.Day14.next_1000_contains_a_quintet?("abc", 39, "e") === true
#   end
#
#   @tag :skip
#   test "hash function" do
#     assert Aoc.Aoc2016.Day14.hash("abc", 18, 0) |> String.contains?("cc38887a5")
#   end
#
#   @tag :skip
#   test "if it is a valid hash" do
#     assert Aoc.Aoc2016.Day14.is_hash?(Aoc.Aoc2016.Day14.hash("abc", 18, 0), "abc", 18) === false
#     assert Aoc.Aoc2016.Day14.is_hash?(Aoc.Aoc2016.Day14.hash("abc", 39, 0), "abc", 39) === true
#   end
#
#   @tag :skip
#   test "get next hash" do
#     assert Aoc.Aoc2016.Day14.get_next_hash("abc", 0) === {"347dac6ee8eeea4652c7476d0f97bee5", 39}
#   end
#   @tag :skip
#   test "solve part 1" do
#     assert Aoc.Aoc2016.Day14.generate_keys("zpqevtbw") === 16106
#   end
#
#   #PART 2
#
#   # @tag :skip
#   test "stretch hash function" do
#     Agent.start_link(fn -> %{} end, name: :cache)
#     assert Aoc.Aoc2016.Day14.hash("abc", 0, 2016) === "sdff"#|> String.contains?("a107ff")
#   end
#
#   @tag :skip
#   test "if it is a valid hash - part 2" do
#     Agent.start_link(fn -> %{} end, name: :cache)
#     assert Aoc.Aoc2016.Day14.is_hash?(Aoc.Aoc2016.Day14.hash("abc", 10, 2016), "abc", 10) === true
#     assert Aoc.Aoc2016.Day14.is_hash?(Aoc.Aoc2016.Day14.hash("abc", 11, 2016), "abc", 11) === false
#   end
#
#   @tag :skip
#   test "get next hash part 2" do
#     Agent.start_link(fn -> %{} end, name: :cache)
#     # assert "infinite loop here" = true
#     assert Aoc.Aoc2016.Day14.get_next_hash("abc", 10) === {"347dac6ee8eeea4652c7476d0f97bee5", 10}
#   end
#
#   @tag :skip
#   test "solve part 2" do
#     Agent.start_link(fn -> %{} end, name: :cache)
#     assert Aoc.Aoc2016.Day14.generate_keys("zpqevtbw") === 161
#   end
#
#
# end
