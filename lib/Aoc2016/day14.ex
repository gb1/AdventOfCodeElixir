defmodule Aoc.Aoc2016.Day14 do

  def generate_keys(salt) do

    Stream.unfold({0,0}, fn({nonce, new_state})->
      {hash, nonce} = get_next_hash(salt, nonce)
      {nonce, {nonce + 1, 0}}
    end)
    |> Enum.take(64)
    |> Enum.at(63)
  end

  def generate_keys_part2(salt) do

    Stream.unfold({0,0}, fn({nonce, new_state})->
      {hash, nonce} = get_next_stretched_hash(salt, nonce)
      {nonce, {nonce + 1, 0}}
    end)
    |> Enum.take(1)
    |> Enum.at(0)
  end

  def get_next_hash({hash, nonce}), do: {hash, nonce}
  def get_next_hash(salt, nonce) do
    hash = hash(salt, nonce)

    if is_hash?(hash, salt, nonce) do
      get_next_hash({hash, nonce})
    else
      get_next_hash(salt, nonce + 1)
    end
  end

  def hash(salt, nonce) do
    :crypto.hash(:md5, (salt <> Integer.to_string(nonce)))
    |> Base.encode16
    |> String.downcase
  end

  def get_next_stretched_hash({hash, nonce}), do: {hash, nonce}
  def get_next_stretched_hash(salt, nonce) do
    IO.inspect (salt <> Integer.to_string(nonce))
    hash = stretched_hash((salt <> Integer.to_string(nonce)), 2017)

    if is_stretched_hash?(hash, (salt <> Integer.to_string(nonce)), nonce) do
    # if is_stretched_hash?("4a81e578d9f43511ab693eee1a75f194", "abc10", 10) do

      IO.inspect nonce
      IO.inspect (salt <> Integer.to_string(nonce))
      get_next_stretched_hash({hash, nonce})
    else
      get_next_stretched_hash(salt, nonce + 1)
    end

  end

  def stretched_hash(salt, 0), do: salt
  def stretched_hash(salt, stretch_no) do
    salt = salt |> String.downcase
    hash = case Agent.get(:cache, &Map.has_key?(&1, salt)) do
      false->
        hash = :crypto.hash(:md5, salt)
        |> Base.encode16
        |> String.downcase
        Agent.update(:cache, &Map.put(&1, salt, hash))
        hash
      true->
        Agent.get(:cache, &Map.get(&1, salt))
    end
        stretched_hash(hash, stretch_no - 1)
  end

  def is_hash?(hash, salt, nonce) do
    contains_triplet?(hash) && next_1000_contains_a_quintet?(salt, nonce, get_triplet(hash))
  end

  def is_stretched_hash?(hash, salt, nonce) do
    contains_triplet?(hash) && next_stretched_1000_contains_a_quintet?(salt, nonce, get_triplet(hash))
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
        if hash(salt, i) |> contains_quintet?(char) do
          {:halt, true}
        else
          {:cont, false}
        end
      end)
  end

  def next_stretched_1000_contains_a_quintet?(salt, count, char) do

    original_salt = salt |> String.replace(Integer.to_string(count), "")

    # IO.inspect(original_salt)
    Enum.reduce_while(count + 1..count + 1000, false, fn(i, acc)->
      # IO.inspect(original_salt <> Integer.to_string(i))
      hash = stretched_hash(original_salt <> Integer.to_string(i), 2017)
      if hash |> contains_quintet?(char) do
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

  # @tag :skip
  test "contains triplet" do
    assert Aoc.Aoc2016.Day14.contains_triplet?("cc38887a5") === true
    assert Aoc.Aoc2016.Day14.contains_triplet?("cc38181817a5") === false
  end

  test "get triplet character" do
    assert Aoc.Aoc2016.Day14.get_triplet("cc38887a5") === "8"
  end

  test "contains quintet" do
    assert Aoc.Aoc2016.Day14.contains_quintet?("cc38887a5", "8") === false
    assert Aoc.Aoc2016.Day14.hash("abc", 816) |> Aoc.Aoc2016.Day14.contains_quintet?("e") === true
  end

  test "contains quintet in the next 1000" do
    assert Aoc.Aoc2016.Day14.next_1000_contains_a_quintet?("abc", 18, "8") === false
    assert Aoc.Aoc2016.Day14.next_1000_contains_a_quintet?("abc", 39, "e") === true
  end

  test "hash function" do
    assert Aoc.Aoc2016.Day14.hash("abc", 18) |> String.contains?("cc38887a5")
  end

  test "if it is a valid hash" do
    assert Aoc.Aoc2016.Day14.is_hash?(Aoc.Aoc2016.Day14.hash("abc", 18), "abc", 18) === false
    assert Aoc.Aoc2016.Day14.is_hash?(Aoc.Aoc2016.Day14.hash("abc", 39), "abc", 39) === true
  end

  test "get next hash" do
    assert Aoc.Aoc2016.Day14.get_next_hash("abc", 0) === {"347dac6ee8eeea4652c7476d0f97bee5", 39}
  end

  @tag :skip
  test "solve part 1" do
    assert Aoc.Aoc2016.Day14.generate_keys("zpqevtbw") === 16106
  end

  @tag :skip
  test "stretched hash function" do
    Agent.start_link(fn -> %{} end, name: :cache)
    assert Aoc.Aoc2016.Day14.stretched_hash("abc0", 2017) |> String.contains?("a107ff")
    assert Aoc.Aoc2016.Day14.stretched_hash("abc0", 2017) |> String.contains?("a107ff")
  end

  @tag :skip
  test "is a valid stretched hash" do
    Agent.start_link(fn -> %{} end, name: :cache)
    assert Aoc.Aoc2016.Day14.is_stretched_hash?("4a81e578d9f43511ab693eee1a75f194", "abc10", 10) === true
    # assert Aoc.Aoc2016.Day14.stretched_hash("abc10", 2017) === ""
  end

  @tag :skip
  test "get next stretched hash" do
    Agent.start_link(fn -> %{} end, name: :cache)
    assert Aoc.Aoc2016.Day14.get_next_stretched_hash("abc",10) === {"4a81e578d9f43511ab693eee1a75f194", 10}
  end

  # @tag :skip
  test "solve part 2" do
    Agent.start_link(fn -> %{} end, name: :cache)
    assert Aoc.Aoc2016.Day14.generate_keys_part2("zpqevtbw") === 16106
  end

end