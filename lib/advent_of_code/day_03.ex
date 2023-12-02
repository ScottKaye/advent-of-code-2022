defmodule AdventOfCode.Day03 do
  defp split_into_compartments(line) do
    half = String.length(line) |> div(2)
    line |> to_charlist() |> Enum.chunk_every(half)
  end

  defp find_common_item([a, b]) do
    Enum.reduce(a, [], fn i, acc ->
      if Enum.member?(b, i) do
        [i | acc]
      else
        acc
      end
    end)
    |> Enum.uniq()
  end

  defp assign_priority(char) do
    Enum.at(char, 0) -
      if char >= ~c"a" and char <= ~c"z" do
        96
      else
        38
      end
  end

  def part1(_args) do
    File.read!("./rucksacks")
    |> String.split("\n", trim: true)
    |> Enum.map(&split_into_compartments/1)
    |> Enum.map(&find_common_item/1)
    |> Enum.map(&assign_priority/1)
    |> Enum.sum()
    |> dbg
  end

  def part2(_args) do
  end
end
