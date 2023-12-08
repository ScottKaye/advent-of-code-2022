defmodule AdventOfCode.Day07 do
  defp split_hand(hand) do
    [cards_str, bid] = String.split(hand, " ", trim: true)

    {cards_str, String.to_integer(bid)}
  end

  defp score_hand({cards_str, bid}) do
    cards =
      cards_str
      |> to_charlist()
      |> Enum.map(fn c ->
        Enum.find_index(~c"23456789TJQKA", &(&1 == c))
      end)

    %{
      :cards => cards,
      :bid => bid,
      :freq =>
        cards_str
        |> to_charlist
        |> Enum.frequencies()
        |> Map.values()
        |> Enum.sort()
        |> Enum.reverse()
    }
  end

  defp score_hand_with_jokers({cards_str, bid}) do
    cards =
      cards_str
      |> to_charlist()
      |> Enum.map(fn c ->
        Enum.find_index(~c"J23456789TQKA", &(&1 == c))
      end)

    freq =
      cards_str
      |> String.replace("J", "")
      |> to_charlist
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort()
      |> Enum.reverse()

    [best | rest] =
      case freq do
        [] -> [0]
        _ -> freq
      end

    joker_count = Enum.count(cards, fn c -> c == 0 end)

    %{
      :cards => cards,
      :bid => bid,
      :freq => [best + joker_count | rest]
    }
  end

  defp score_entire_game(game) do
    game
    |> Enum.sort_by(&{&1.freq, &1.cards})
    |> Enum.map(& &1.bid)
    |> Enum.with_index(1)
    |> Enum.map(fn {bid, index} -> bid * index end)
    |> Enum.sum()
  end

  def part1(_args) do
    AdventOfCode.Input.get!(7, 2023)
    |> String.split("\n", trim: true)
    |> Enum.map(&split_hand/1)
    |> Enum.map(&score_hand/1)
    |> score_entire_game()
  end

  def part2(_args) do
    AdventOfCode.Input.get!(7, 2023)
    |> String.split("\n", trim: true)
    |> Enum.map(&split_hand/1)
    |> Enum.map(&score_hand_with_jokers/1)
    |> score_entire_game()
  end
end
