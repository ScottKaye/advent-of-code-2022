defmodule AdventOfCode.Day05 do
  defp get_seeds(input) do
    Regex.run(~r/seeds: (.+?)\n/, input, capture: :all_but_first)
    |> hd()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp get_seeds_ranges(input) do
    get_seeds(input)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, count] ->
      start..(start + count - 1)
    end)
  end

  defp get_maps(input) do
    Regex.scan(~r/^(.+?) map:\n([\d ]*\n)+/m, input, capture: :first)
    |> Enum.map(fn group ->
      [title | maps] = group |> hd |> String.split("\n", trim: true)

      {
        title,
        maps
        |> Enum.map(fn map ->
          map
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)
      }
    end)
  end

  defp get_map_result(value, {_name, maps}) do
    result =
      Enum.find(maps, fn [_, source_start, range] ->
        value >= source_start && value <= source_start + (range - 1)
      end)

    case result do
      [destination_start, source_start, _] ->
        destination_start + (value - source_start)

      nil ->
        value
    end
  end

  def part1(_args) do
    # Seed number 79 corresponds to soil number 81.
    # seed-to-soil range that matches is source 50 of length 48 because:
    #   79 >= 50
    #   79 < 50 + (48 - 1) (which is 97)
    # 52 + (79 - 50) = 81

    # seed 51 goes to soil 53
    # 51 > 50 so we're using map 2
    # 52 + (51 - 50) = 53

    # seed 54 goes to soil 56
    # 52 + (54 - 50) = 56

    input = AdventOfCode.Input.get!(5, 2023)

    seeds = get_seeds(input)
    maps = get_maps(input)

    for seed <- seeds do
      seed_to_soil = get_map_result(seed, Enum.at(maps, 0))
      soil_to_fertilizer = get_map_result(seed_to_soil, Enum.at(maps, 1))
      fertilizer_to_water = get_map_result(soil_to_fertilizer, Enum.at(maps, 2))
      water_to_light = get_map_result(fertilizer_to_water, Enum.at(maps, 3))
      light_to_temperature = get_map_result(water_to_light, Enum.at(maps, 4))
      temperature_to_humidity = get_map_result(light_to_temperature, Enum.at(maps, 5))
      humidity_to_location = get_map_result(temperature_to_humidity, Enum.at(maps, 6))

      humidity_to_location
    end
    |> Enum.min()
  end

  def part2(_args) do
    input = AdventOfCode.Input.get!(5, 2023)

    maps = get_maps(input)
    seed_ranges = get_seeds_ranges(input)

    {:ok, result} =
      Task.async_stream(
        seed_ranges,
        fn seed_range ->
          Enum.reduce(seed_range, nil, fn seed, lowest_location ->
            location =
              Enum.reduce(maps, seed, fn map, prev ->
                get_map_result(prev, map)
              end)

            if rem(seed, 1_000_000) == 0 do
              IO.puts("Checking #{seed}, current lowest is #{lowest_location}")
            end

            if location < lowest_location do
              location
            else
              lowest_location
            end
          end)
        end,
        ordered: false,
        timeout: :infinity
      )
      |> Enum.min()

    result
  end
end
