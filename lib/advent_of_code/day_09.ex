defmodule AdventOfCode.Day09 do
  defp last(enum), do: Enum.at(enum, -1)

  defp fill_differences(tree) do
    last_line = last(tree)

    if Enum.all?(last_line, &(&1 == 0)) do
      tree
    else
      diffs =
        Enum.chunk_every(last_line, 2, 1)
        |> Enum.filter(&(length(&1) == 2))
        |> Enum.map(fn [left, right] -> right - left end)

      fill_differences(tree ++ [diffs])
    end
  end

  defp extrapolate([_, b | tail], next) do
    extrapolate([b] ++ tail, last(b) + next)
  end

  defp extrapolate(_, next), do: next

  defp extrapolate_part2([_, b | tail], next) do
    extrapolate_part2([b] ++ tail, hd(b) - next)
  end

  defp extrapolate_part2(_, next), do: next

  defp prepare_lines() do
    AdventOfCode.Input.get!(9, 2023)
    |> AdventOfCode.Input.as_lines()
    |> Enum.map(fn line ->
      line =
        String.split(line, " ", trim: true)
        |> Enum.map(&String.to_integer/1)

      fill_differences([line]) |> Enum.reverse()
    end)
  end

  def part1(_args) do
    prepare_lines()
    |> Enum.map(&extrapolate(&1, 0))
    |> Enum.sum()
  end

  def part2(_args) do
    prepare_lines()
    |> Enum.map(&extrapolate_part2(&1, 0))
    |> Enum.sum()
  end
end
