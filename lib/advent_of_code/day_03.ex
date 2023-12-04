defmodule AdventOfCode.Day03 do
  defp get_cell(matrix, x, y) do
    row = matrix |> Enum.at(y)

    case row do
      nil -> nil
      _ -> row |> Enum.at(x)
    end
  end

  defp get_number_from_range(matrix, {y, {x1, x2}}) do
    Enum.slice(Enum.at(matrix, y), x1, x2 - x1)
    |> Enum.reduce("", fn acc, c ->
      "#{c}#{acc}"
    end)
    |> String.to_integer()
  end

  defp get_number_range(matrix, x, y) do
    cell = get_cell(matrix, x, y)

    case cell do
      nil ->
        nil

      _ ->
        case Integer.parse(cell) do
          :error ->
            nil

          {_, _} ->
            start_index =
              Enum.reduce_while(Enum.at(matrix, y), x, fn _, x ->
                cell = get_cell(matrix, x, y)

                next_value =
                  cond do
                    _ = Regex.run(~r/\d/, cell) ->
                      true

                    true ->
                      nil
                  end

                case next_value do
                  nil -> {:halt, x + 1}
                  _ -> {:cont, x - 1}
                end
              end)

            end_index =
              Enum.reduce_while(Enum.at(matrix, y), start_index, fn _, x ->
                cell = get_cell(matrix, x, y)

                cond do
                  _ = Regex.run(~r/\d/, cell) ->
                    {:cont, x + 1}

                  true ->
                    {:halt, x}
                end
              end)

            {y, {start_index, end_index}}
        end
    end
  end

  defp find_adjacent_numbers(matrix, x, y) do
    top_left = get_number_range(matrix, x - 1, y - 1)
    top = get_number_range(matrix, x, y - 1)
    top_right = get_number_range(matrix, x + 1, y - 1)

    middle_left = get_number_range(matrix, x - 1, y)
    middle_right = get_number_range(matrix, x + 1, y)

    bottom_left = get_number_range(matrix, x - 1, y + 1)
    bottom = get_number_range(matrix, x, y + 1)
    bottom_right = get_number_range(matrix, x + 1, y + 1)

    [
      top_left,
      top,
      top_right,
      middle_left,
      middle_right,
      bottom_left,
      bottom,
      bottom_right
    ]
    |> Enum.uniq()
    |> Enum.reject(&is_nil/1)
  end

  def part1(_args) do
    matrix =
      AdventOfCode.Input.get!(3, 2023)
      |> String.split("\n", trim: true)
      |> Enum.map(&(&1 |> String.split("")))

    y_max = length(matrix) - 1
    x_max = (matrix |> List.first() |> length()) - 1

    for y <- 0..y_max, x <- 0..x_max do
      cell = get_cell(matrix, x, y)

      cond do
        String.length(cell) == 0 ->
          nil

        cell == "." ->
          nil

        _ = Regex.run(~r/\d/, cell) ->
          nil

        true ->
          find_adjacent_numbers(matrix, x, y)
      end
    end
    |> Enum.reject(&is_nil/1)
    |> List.flatten()
    |> Enum.map(&get_number_from_range(matrix, &1))
    |> Enum.sum()
    |> dbg
  end

  def part2(_args) do
    matrix =
      AdventOfCode.Input.get!(3, 2023)
      |> String.split("\n", trim: true)
      |> Enum.map(&(&1 |> String.split("")))

    y_max = length(matrix) - 1
    x_max = (matrix |> List.first() |> length()) - 1

    for y <- 0..y_max, x <- 0..x_max do
      cell = get_cell(matrix, x, y)

      cond do
        cell == "*" ->
          find_adjacent_numbers(matrix, x, y)

        true ->
          nil
      end
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn i ->
      Enum.map(i, fn j -> get_number_from_range(matrix, j) end)
    end)
    |> Enum.filter(&(length(&1) == 2))
    |> Enum.map(fn [a, b] ->
      a * b
    end)
    |> Enum.sum()
  end
end
