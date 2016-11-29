defmodule Aoc.Aoc2015.Day14 do

  @doc """
  iex>Aoc.Aoc2015.Day14.run_for_input
  [2548, 1102]
  """
  def run_for_input do

    reindeers = [
      %{ :active => true, :speed => 27, :stamina => 5, :rest => 132, :remaining_flight_time => 5, :remaining_rest_time => 0, :distance => 0, :points => 0 },
      %{ :active => true, :speed => 22, :stamina => 2, :rest => 41, :remaining_flight_time => 2, :remaining_rest_time => 0, :distance => 0, :points => 0 },
      %{ :active => true, :speed => 11, :stamina => 5, :rest => 48, :remaining_flight_time => 5, :remaining_rest_time => 0, :distance => 0, :points => 0 },
      %{ :active => true, :speed => 28, :stamina => 5, :rest => 134, :remaining_flight_time => 5, :remaining_rest_time => 0, :distance => 0, :points => 0 },
      %{ :active => true, :speed => 14, :stamina => 3, :rest => 38, :remaining_flight_time => 3, :remaining_rest_time => 0, :distance => 0, :points => 0 },
      %{ :active => true, :speed => 4, :stamina => 16, :rest => 55, :remaining_flight_time => 16, :remaining_rest_time => 0, :distance => 0, :points => 0 },
      %{ :active => true, :speed => 3, :stamina => 21, :rest => 40, :remaining_flight_time => 21, :remaining_rest_time => 0, :distance => 0, :points => 0 },
      %{ :active => true, :speed => 18, :stamina => 6, :rest => 103, :remaining_flight_time => 6, :remaining_rest_time => 0, :distance => 0, :points => 0 },
      %{ :active => true, :speed => 18, :stamina => 5, :rest => 84, :remaining_flight_time => 5, :remaining_rest_time => 0, :distance => 0, :points => 0 }
    ]

    IO.inspect tick(reindeers, 2503)

    tick(reindeers, 2503) |> Enum.max
  end


  @doc """
  iex>Aoc.Aoc2015.Day14.tick([%{ :active => true, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 10, :remaining_rest_time => 0, :distance => 0, :points => 0  }, %{ :active => true, :speed => 16, :stamina => 11, :rest => 162, :remaining_flight_time => 11, :remaining_rest_time => 0, :distance => 0, :points => 0 }], 1000)
  [[1120,312], [1056,689]]

  iex>Aoc.Aoc2015.Day14.tick([%{ :active => true, :speed => 11, :stamina => 5, :rest => 48, :remaining_flight_time => 5, :remaining_rest_time => 0, :distance => 0, :points => 0  }], 2503)
  [[2640, 2503]]
  """
  def tick(reindeers, 0) do
    reindeers |> Enum.map(fn(reindeer) ->
      [ reindeer |> Map.get(:distance), reindeer |> Map.get(:points)]
    end)
  end

  def tick(reindeers, n) do

    reindeers = reindeers |> Enum.map(fn(reindeer) ->
      case reindeer[:active] do
        true -> process_active( reindeer )
        false -> process_inactive( reindeer )
      end
    end)

    #who's leading?
    leading_distance = reindeers |> Enum.reduce(0, fn(reindeer, distance) ->
      cond do
        reindeer[:distance] > distance -> reindeer[:distance]
        true -> distance
      end
    end)

    reindeers = reindeers |> Enum.map( fn(reindeer) ->
      cond do
        reindeer[:distance] == leading_distance -> Map.put(reindeer, :points, reindeer[:points] + 1)
        true -> reindeer
       end
     end)

    tick(reindeers, n-1)
  end


  @doc """
  iex>Aoc.Aoc2015.Day14.process_active(%{ :active => true, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 10, :remaining_rest_time => 0, :distance => 0 })
  %{ :active => true, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 9, :remaining_rest_time => 0, :distance => 14 }

  iex>Aoc.Aoc2015.Day14.process_active(%{ :active => true, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 0, :remaining_rest_time => 0, :distance => 0 })
  %{ :active => false, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 0, :remaining_rest_time => 125, :distance => 0 }

  """
  def process_active(reindeer) do
    case reindeer[:remaining_flight_time] do
      0 ->
        Map.put(reindeer, :active, false)
        |> Map.put(:remaining_rest_time, reindeer[:rest] - 2)
      _ ->
        Map.put(reindeer, :remaining_flight_time, reindeer[:remaining_flight_time] - 1)
        |> Map.put( :distance, reindeer[:distance] + reindeer[:speed])
    end
  end

  @doc """
  iex>Aoc.Aoc2015.Day14.process_inactive(%{ :active => false, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 0, :remaining_rest_time => 5, :distance => 14 , :points => 0 })
  %{ :active => false, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 0, :remaining_rest_time => 4, :distance => 14, :points => 0 }

  iex>Aoc.Aoc2015.Day14.process_inactive(%{ :active => false, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 0, :remaining_rest_time => 0, :distance => 14 , :points => 0 })
  %{ :active => true, :speed => 14, :stamina => 10, :rest => 127, :remaining_flight_time => 10, :remaining_rest_time => 0, :distance => 14 , :points => 0 }
  """

  def process_inactive(reindeer) do
    case reindeer[:remaining_rest_time] do
      0 ->
        Map.put(reindeer, :active, true)
        |> Map.put(:remaining_flight_time, reindeer[:stamina])
      _ ->
        Map.put(reindeer, :remaining_rest_time, reindeer[:remaining_rest_time] - 1)
    end
  end
end
