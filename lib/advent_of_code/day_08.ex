defmodule AdventOfCode.Day08 do
  defp lcm(a, b), do: div(abs(a * b), Integer.gcd(a, b))

  defp get_directions(input) do
    [first | _] = String.split(input, "\n", trim: true)

    first |> String.split("", trim: true)
  end

  defp get_steps(input) do
    for [start, left, right] <-
          Regex.scan(~r/(.{3}) = \((.{3}), (.{3})\)/, input, capture: :all_but_first) do
      {start, left, right}
    end
  end

  defp traverse(steps, [direction | remaining_directions], current_steps, current_step) do
    if String.ends_with?(current_step, "Z") do
      current_steps
    else
      {_, left, right} = Enum.find(steps, fn {pos, _, _} -> pos == current_step end)

      next_step =
        case direction do
          "L" -> left
          _ -> right
        end

      traverse(steps, remaining_directions ++ [direction], current_steps + 1, next_step)
    end
  end

  def part1(_args) do
    input = AdventOfCode.Input.get!(8, 2023)
    directions = get_directions(input)
    steps = get_steps(input)

    traverse(steps, directions, 0, "AAA")
  end

  def part2(_args) do
    input = AdventOfCode.Input.get!(8, 2023)
    directions = get_directions(input)
    steps = get_steps(input)

    starting_steps =
      steps
      |> Enum.map(&elem(&1, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    for starting_step <- starting_steps do
      traverse(steps, directions, 0, starting_step)
    end
    |> Enum.reduce(&lcm(&1, &2))
  end
end
