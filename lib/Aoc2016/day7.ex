defmodule Aoc.Aoc2016.Day7 do

  @doc """
  iex>Aoc.Aoc2016.Day7.part1
  110
  """
  def part1 do
    {:ok, file} = File.read("./lib/Aoc2016/day7.txt")
    file
    |> String.split("\n")
    |> Enum.reduce(0, fn(line, acc)->
      case line |> supports_tls do
        true -> acc + 1
        false -> acc
      end
    end)
  end

  @doc """
  iex>Aoc.Aoc2016.Day7.part2
  242
  """
  def part2 do
    {:ok, file} = File.read("./lib/Aoc2016/day7.txt")
    file
    |> String.split("\n")
    |> Enum.reduce(0, fn(line, acc)->
      case line |> supports_ssl do
        true -> acc + 1
        false -> acc
      end
    end)
  end

  @doc """
  iex>Aoc.Aoc2016.Day7.supports_ssl("aba[bab]xyz")
  true
  """
  def supports_ssl(string) do
    [normal_bits, hypernet_seqs] = string |> split_out_hypernet_sequences

    babs = normal_bits
    |> Enum.reduce([], fn(line, acc)->
      List.insert_at(acc, 0, line
      |> get_abas_and_babs
      |> get_required_babs)
    end)
    |> List.flatten

    babs
    |> Enum.reduce_while( false, fn(bab, acc)->
      contains = hypernet_seqs |> Enum.reduce_while(false, fn(seq, acc)->
        if seq |> String.contains?(bab) do
          acc = true
          {:halt, true}
        else
          acc = false
          {:cont, false}
        end
      end)

      case contains do
        true -> {:halt, true}
        false -> {:cont, false}
      end
    end)
  end

  @doc ~S"""
  iex>Aoc.Aoc2016.Day7.get_required_babs([{"aba", "bab"}])
  ["bab"]
  """
  def get_required_babs(abas_and_babs) do
    abas_and_babs
    |> Enum.map(&(elem(&1, 1)))
  end

  @doc ~S"""
  Get a list of ABAs and the corresponding BAB values needed

  iex>Aoc.Aoc2016.Day7.get_abas_and_babs("aba")
  [{"aba", "bab"}]
  """
  def get_abas_and_babs(string) do
    string
    |> String.codepoints
    |> Enum.chunk(3,1)
    |> Enum.map( &(Enum.join(&1)))
    |> Enum.reduce([], fn(chunk, acc)->
      [left,middle,right] = chunk |> String.codepoints
      if left === right and left !== middle do
        acc |> List.insert_at(0, {chunk, Enum.join([middle, left, middle])})
      else
        acc
      end
    end)
  end

  @doc """
  iex>Aoc.Aoc2016.Day7.supports_tls("abba[mnop]qrst")
  true
  iex>Aoc.Aoc2016.Day7.supports_tls("abcd[bddb]xyyx")
  false
  iex>Aoc.Aoc2016.Day7.supports_tls("aaaa[qwer]tyui")
  false
  iex>Aoc.Aoc2016.Day7.supports_tls("ioxxoj[asdfgh]zxcvbn")
  true
  """
  def supports_tls(string) do
    [normal_bits, hypernet_seqs] = string |> split_out_hypernet_sequences

    normal_bits |> Enum.any?( &(is_abba(&1))) &&
    hypernet_seqs |> Enum.filter( &(is_abba(&1))) === []

  end

  @doc """
  iex>Aoc.Aoc2016.Day7.split_out_hypernet_sequences("rhamaeovmbheijj[hkwbkqzlcscwjkyjulk]ajsxfuemamuqcjccbc")
  [["rhamaeovmbheijj", "ajsxfuemamuqcjccbc"], ["hkwbkqzlcscwjkyjulk"]]
  """
  def split_out_hypernet_sequences(string) do
    [ string |> String.split(~r/\[(.*)\]/U)
    |> Enum.filter(&(&1 !== "")),
    string
    |> (&Regex.scan(~r/\[(.*)\]/U, &1)).()
    |> Enum.map( &(Enum.at(&1,1)))]
  end

  @doc """
  iex>Aoc.Aoc2016.Day7.is_abba("abba")
  true
  iex>Aoc.Aoc2016.Day7.is_abba("aaaa")
  false
  iex>Aoc.Aoc2016.Day7.is_abba("ioxxoj")
  true
  """
  def is_abba(string) do

    string
    |> String.codepoints
    |> Enum.chunk(4,1)
    |> Enum.map( &(Enum.join(&1)))
    |> Enum.reduce_while(false, fn(chunk, _)->
      [ab,_,ba] = chunk
      |> String.codepoints
      |> Enum.chunk(2,1)
      if ab == Enum.reverse(ba) && ab !== ba do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end
end
