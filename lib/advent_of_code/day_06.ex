defmodule AdventOfCode.Day06 do
  defp parse_input(input) do
    ["Time:" <> time, "Distance:" <> distance] = String.split(input, "\n", trim: true)

    times = String.split(time, " ", trim: true) |> Enum.map(&String.to_integer/1)
    distances = String.split(distance, " ", trim: true) |> Enum.map(&String.to_integer/1)

    Enum.zip(times, distances)
  end

  defp parse_input_without_spaces(input) do
    ["Time:" <> time, "Distance:" <> distance] = String.split(input, "\n", trim: true)

    time = String.replace(time, " ", "") |> String.to_integer()
    distance = String.replace(distance, " ", "") |> String.to_integer()

    {time, distance}
  end

  defp calculate_wins({duration, distance_to_beat}) do
    for ms <- 1..(duration - 1), reduce: 0 do
      wins ->
        if ms * (duration - ms) > distance_to_beat do
          wins + 1
        else
          wins
        end
    end
  end

  def part1(_args) do
    AdventOfCode.Input.get!(6, 2023)
    |> parse_input
    |> Enum.map(&calculate_wins/1)
    |> Enum.reduce(fn i, total -> i * total end)
  end

  def part2(_args) do
    AdventOfCode.Input.get!(6, 2023)
    |> parse_input_without_spaces()
    |> calculate_wins
  end
end
