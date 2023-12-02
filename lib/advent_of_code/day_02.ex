defmodule AdventOfCode.Day02 do
  defp is_possible?(rounds, bag) do
    Enum.all?(rounds, fn round ->
      Enum.all?(round, fn {color, count} ->
        Map.get(bag, color) >= count
      end)
    end)
  end

  defp get_rounds(game_str) do
    game_str
    |> String.split(";")
    |> Enum.map(fn round ->
      round
      |> String.split(",")
      |> Enum.reduce(%{}, fn draw, acc ->
        [count, color] = Regex.run(~r/(\d+) (red|green|blue)/, draw, capture: :all_but_first)

        Map.put(acc, color, String.to_integer(count))
      end)
    end)
  end

  defp parse_game_string(line) do
    [game_str] = Regex.run(~r/: (.+?)$/, line, capture: :all_but_first)
    game_str
  end

  # correct result: 2795
  def part1(_args) do
    bag = %{
      "red" => 12,
      "green" => 13,
      "blue" => 14
    }

    AdventOfCode.Input.get!(2, 2023)
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> parse_game_string |> get_rounds |> is_possible?(bag)))
    |> Enum.zip(1..100)
    |> Enum.reduce(0, fn {is_possible, i}, acc ->
      acc + if is_possible, do: i, else: 0
    end)
  end

  # correct result: 75561
  def part2(_args) do
    AdventOfCode.Input.get!(2, 2023)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> parse_game_string
      |> get_rounds
      |> Enum.reduce(%{}, &Map.merge(&1, &2, fn _, v1, v2 -> max(v1, v2) end))
      |> Enum.reduce(1, fn {_, count}, acc -> acc * count end)
    end)
    |> Enum.sum()
  end
end
