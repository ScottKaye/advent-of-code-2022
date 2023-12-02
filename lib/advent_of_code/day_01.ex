defmodule AdventOfCode.Day01 do
  def part1(_args) do
    AdventOfCode.Input.get!(1, 2023)
    |> String.replace(~r/[^\d\n]/, "")
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      "#{String.slice(str, 0..0)}#{String.slice(str, -1..-1)}" |> String.to_integer()
    end)
    |> Enum.sum()
  end

  defp find_first_number(str) do
    [result] =
      Regex.run(~r/(\d|one|two|three|four|five|six|seven|eight|nine)/, str, capture: :first)

    result
  end

  defp find_last_number(str) do
    [result] =
      Regex.run(~r/(\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)/, String.reverse(str),
        capture: :first
      )

    result |> String.reverse()
  end

  defp resolve_digit(digit) do
    case digit do
      "one" -> 1
      "two" -> 2
      "three" -> 3
      "four" -> 4
      "five" -> 5
      "six" -> 6
      "seven" -> 7
      "eight" -> 8
      "nine" -> 9
      _ -> digit
    end
  end

  defp find_number(i) do
    "#{find_first_number(i) |> resolve_digit}#{find_last_number(i) |> resolve_digit}"
    |> String.to_integer()
  end

  # correct result: 53221
  def part2(_args) do
    AdventOfCode.Input.get!(1, 2023)
    |> String.split("\n", trim: true)
    |> Enum.map(&find_number/1)
    |> Enum.sum()
  end
end
