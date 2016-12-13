defmodule Aoc.Aoc2016.Day11 do

  @end_state [{:floor, 4}, [],[],[],["HG", "HM", "LG", "LM"]]

  def get_all_states do


    list = [{:floor, 1}, ["HM", "LM"],["HG"],["LG"],[]]

  end

  # def move_up(state) do
  #   Enum.at(0)
  # end

  def is_legal_state?(state) do
    state
    |> Enum.drop(1)
    |> Enum.reduce_while(true, fn(floor, legal)->

    end)
  end

  @doc """
  iex>Aoc.Aoc2016.Day11.will_chip_be_fried?(["HM", "LM"])
  false
  """
  def will_chip_be_fried?(floor_state) do
    false
  end

end
