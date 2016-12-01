defmodule Aoc.Aoc2015.Day19 do

  require IEx

  @doc """
  iex>Aoc.Aoc2015.Day19.go
  []
  """
  def go do

    molecule = "CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl"

    subs = %{ 'Al' => 'ThF',
              'Al' => 'ThRnFAr',
              'B' => 'BCa',
              'B' => 'TiB',
              'B' => 'TiRnFAr',
              'Ca' => 'CaCa',
              'Ca' => 'PB'
    }

    molecule
    |> to_charlist
    |> Enum.chunk(2)
    |> Enum.reduce([], fn(chunk, acc) ->

      if Map.has_key?(subs, chunk) do
         acc ++ [ chunk ]
      else
        acc
      end
    end)

  end


end

ExUnit.start

defmodule Aoc.Aoc2015.Day19Test do
  use ExUnit.Case, async: true

  test "ok" do
    assert true = true
  end

end
