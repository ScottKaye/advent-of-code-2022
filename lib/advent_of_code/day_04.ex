defmodule AdventOfCode.Day04 do
  defp parse_card(line) do
    [card_id, winners, have] =
      Regex.run(~r/Card\s+(\d+): (.+?) \| (.+?)$/, line, capture: :all_but_first)

    parse_number_string = fn str ->
      str |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    end

    %{
      :card_id => card_id |> String.to_integer(),
      :winners => parse_number_string.(winners),
      :have => parse_number_string.(have)
    }
  end

  defp find_winning_numbers(card) do
    MapSet.intersection(MapSet.new(card.winners), MapSet.new(card.have)) |> Enum.to_list()
  end

  defp get_score([]) do
    0
  end

  defp get_score(winners) do
    2 ** (length(winners) - 1)
  end

  def part1(_args) do
    AdventOfCode.Input.get!(4, 2023)
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_card/1)
    |> Enum.map(&find_winning_numbers/1)
    |> Enum.map(&get_score/1)
    |> Enum.sum()
  end

  def part2(_args) do
    counts =
      AdventOfCode.Input.get!(4, 2023)
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_card/1)
      |> Enum.map(
        &{
          &1.card_id,
          &1 |> find_winning_numbers |> length
        }
      )

    initial_map =
      counts
      |> Enum.reduce(%{}, fn {card_id, _}, map ->
        Map.put(map, card_id, 1)
      end)

    counts
    |> Enum.reduce(initial_map, fn {card_id, wins}, map ->
      case wins do
        0 ->
          map

        _ ->
          for i <- card_id..(card_id + wins - 1) do
            i + 1
          end
          |> Enum.reduce(map, fn i, map ->
            value = Map.get(map, i, 1)
            times = Map.get(map, card_id, 1)
            Map.put(map, i, value + times)
          end)
      end
    end)
    |> Map.values()
    |> Enum.sum()
  end
end
