defmodule Aoc.Aoc2016.Day14 do

  def generate_keys(salt) do

    Stream.unfold({0,0}, fn({nonce, new_state})->
      {hash, nonce} = get_next_hash(salt, nonce)
      IO.puts nonce
      {nonce, {nonce + 1, 0}}
    end)
    |> Enum.take(64)
    |> Enum.at(63)
  end

  def get_next_hash({hash, nonce}), do: {hash, nonce}
  def get_next_hash(salt, nonce) do
    hash = get_hash_for_string(salt, nonce)

    if is_hash?(hash, salt, nonce) do
      get_next_hash({hash, nonce})
    else
      get_next_hash(salt, nonce + 1)
    end
  end

  def get_hash_for_string(salt, nonce) do
    string = salt <> Integer.to_string(nonce)
    if Agent.get(:cache, &Map.has_key?(&1, string)) do
      # IO.puts "found in cache"
      Agent.get(:cache, &Map.get(&1, string))
    else
      hash = hash(salt, nonce)
      Agent.update(:cache, &Map.put(&1, string, hash))
      hash
    end
  end

  def hash(salt, nonce, stretch \\ 2017)

  def hash(salt, nonce, 0) do
    salt
  end

  def hash(salt, nonce, stretch) do

    new_salt = case stretch do
      2017 ->
        :crypto.hash(:md5, (salt <> Integer.to_string(nonce)))
        |> Base.encode16
        |> String.downcase
      _->
        :crypto.hash(:md5, salt)
        |> Base.encode16
        |> String.downcase
    end

    hash(new_salt, nonce, stretch - 1)
  end

  def is_hash?(hash, salt, nonce) do
    contains_triplet?(hash) && next_1000_contains_a_quintet?(salt, nonce, get_triplet(hash))
  end

  def contains_triplet?(hash) do
    hash
    |> String.split("")
    |> Enum.chunk_by(&(&1))
    |> Enum.any?(&(length(&1) >= 3))
  end

  def get_triplet(hash) do
    hash
    |> String.split("")
    |> Enum.chunk_by(&(&1))
    |> Enum.sort(&(length(&1) > length(&2)))
    |> List.first
    |> List.first
  end

  def contains_quintet?(hash,  char) do
    hash
    |> String.contains?(char <> char <> char <> char <> char)
  end

  def next_1000_contains_a_quintet?(salt, count, char) do
    Enum.reduce_while(count + 1..count + 1000, false, fn(i, acc)->
      if get_hash_for_string(salt, i) |> contains_quintet?(char) do
              # update_cache(i, char)
              # Agent.update(:cache, &MapSet.put(&1, {i, char}))
              {:halt, true}
      else
              {:cont, false}
      end
    end)
  end

  def update_cache(i, char) do
    for n <- i-1000..i do
      Agent.update(:cache, &MapSet.put(&1, {n, char}))
    end

    Agent.get(:cache, &IO.inspect(&1))
  end

  def look_in_cache?(count, char) do

    Enum.reduce_while(count + 1..count + 1000, false, fn(i, acc)->

      if Agent.get(:cache, &MapSet.member?(&1, {i, char})) do
        IO.puts "found in cache"
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

end


ExUnit.start(exclude: [:skip])
ExUnit.configure(timeout: :infinity)

defmodule Aoc.Aoc2016.Day14Test do
  use ExUnit.Case, async: true

  @tag :skip
  test "contains triplet" do
    assert Aoc.Aoc2016.Day14.contains_triplet?("cc38887a5") === true
    assert Aoc.Aoc2016.Day14.contains_triplet?("cc38181817a5") === false
  end

  @tag :skip
  test "get triplet character" do
    assert Aoc.Aoc2016.Day14.get_triplet("cc38887a5") === "8"
  end

  @tag :skip
  test "contains quintet" do
    assert Aoc.Aoc2016.Day14.contains_quintet?("cc38887a5", "8") === false
    assert Aoc.Aoc2016.Day14.hash("abc", 816) |> Aoc.Aoc2016.Day14.contains_quintet?("e") === true
  end

  @tag :skip
  test "contains quintet in the next 1000" do
    assert Aoc.Aoc2016.Day14.next_1000_contains_a_quintet?("abc", 18, "8") === false
    assert Aoc.Aoc2016.Day14.next_1000_contains_a_quintet?("abc", 39, "e") === true
  end

  @tag :skip
  test "hash function" do
    assert Aoc.Aoc2016.Day14.hash("abc", 18) |> String.contains?("cc38887a5")
  end

  @tag :skip
  test "if it is a valid hash" do
    assert Aoc.Aoc2016.Day14.is_hash?(Aoc.Aoc2016.Day14.hash("abc", 18), "abc", 18) === false
    assert Aoc.Aoc2016.Day14.is_hash?(Aoc.Aoc2016.Day14.hash("abc", 39), "abc", 39) === true
  end

 @tag :skip
  test "get next hash" do
    assert Aoc.Aoc2016.Day14.get_next_hash("abc", 0) === {"347dac6ee8eeea4652c7476d0f97bee5", 39}
  end

  @tag :skip
  test "solve part 1" do
    assert Aoc.Aoc2016.Day14.generate_keys("zpqevtbw") === 16106
  end

  ### PART 2 ###

  # @tag :skip
  test "stretch hash function" do
    Agent.start_link(fn -> %{} end, name: :cache)
    assert Aoc.Aoc2016.Day14.get_hash_for_string("abc", 0) |> String.contains?("a107ff")
  end

  @tag :skip
  test "get next stretched hash" do
    IO.puts "testing..."
    Agent.start_link(fn -> %{} end, name: :cache)
    assert Aoc.Aoc2016.Day14.get_next_hash("abc", 0) === {"4a81e578d9f43511ab693eee1a75f194", 10}

      # Agent.get(:cache, &IO.inspect(&1 |> Enum.at(0)))

    # assert Aoc.Aoc2016.Day14.look_in_cache?(11, "e") === true

    assert Aoc.Aoc2016.Day14.get_next_hash("abc", 11) === {"820c37e4d1eee5bb88ee3c5ff5cb702b", 25}
    assert Aoc.Aoc2016.Day14.get_next_hash("abc", 26) === {"6289d4f7290ced8167dcd2c2c555b683", 1471}
    # assert Aoc.Aoc2016.Day14.get_next_hash("abc", 11) === {"820c37e4d1eee5bb88ee3c5ff5cb702b", 26}
    #assert Aoc.Aoc2016.Day14.get_next_hash("zpqevtbw", 0) === {"820c37e4d1eee5bb88ee3c5ff5c2b", 26}
  end

  # @tag :skip
  test "solve part 2" do
    Agent.start_link(fn -> %{} end, name: :cache)
    assert Aoc.Aoc2016.Day14.generate_keys("zpqevtbw") === 16106
  end

end
