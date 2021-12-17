challenge_input = [
  4,
  1,
  4,
  1,
  3,
  3,
  1,
  4,
  3,
  3,
  2,
  1,
  1,
  3,
  5,
  1,
  3,
  5,
  2,
  5,
  1,
  5,
  5,
  1,
  3,
  2,
  5,
  3,
  1,
  3,
  4,
  2,
  3,
  2,
  3,
  3,
  2,
  1,
  5,
  4,
  1,
  1,
  1,
  2,
  1,
  4,
  4,
  4,
  2,
  1,
  2,
  1,
  5,
  1,
  5,
  1,
  2,
  1,
  4,
  4,
  5,
  3,
  3,
  4,
  1,
  4,
  4,
  2,
  1,
  4,
  4,
  3,
  5,
  2,
  5,
  4,
  1,
  5,
  1,
  1,
  1,
  4,
  5,
  3,
  4,
  3,
  4,
  2,
  2,
  2,
  2,
  4,
  5,
  3,
  5,
  2,
  4,
  2,
  3,
  4,
  1,
  4,
  4,
  1,
  4,
  5,
  3,
  4,
  2,
  2,
  2,
  4,
  3,
  3,
  3,
  3,
  4,
  2,
  1,
  2,
  5,
  5,
  3,
  2,
  3,
  5,
  5,
  5,
  4,
  4,
  5,
  5,
  4,
  3,
  4,
  1,
  5,
  1,
  3,
  4,
  4,
  1,
  3,
  1,
  3,
  1,
  1,
  2,
  4,
  5,
  3,
  1,
  2,
  4,
  3,
  3,
  5,
  4,
  4,
  5,
  4,
  1,
  3,
  1,
  1,
  4,
  4,
  4,
  4,
  3,
  4,
  3,
  1,
  4,
  5,
  1,
  2,
  4,
  3,
  5,
  1,
  1,
  2,
  1,
  1,
  5,
  4,
  2,
  1,
  5,
  4,
  5,
  2,
  4,
  4,
  1,
  5,
  2,
  2,
  5,
  3,
  3,
  2,
  3,
  1,
  5,
  5,
  5,
  4,
  3,
  1,
  1,
  5,
  1,
  4,
  5,
  2,
  1,
  3,
  1,
  2,
  4,
  4,
  1,
  1,
  2,
  5,
  3,
  1,
  5,
  2,
  4,
  5,
  1,
  2,
  3,
  1,
  2,
  2,
  1,
  2,
  2,
  1,
  4,
  1,
  3,
  4,
  2,
  1,
  1,
  5,
  4,
  1,
  5,
  4,
  4,
  3,
  1,
  3,
  3,
  1,
  1,
  3,
  3,
  4,
  2,
  3,
  4,
  2,
  3,
  1,
  4,
  1,
  5,
  3,
  1,
  1,
  5,
  3,
  2,
  3,
  5,
  1,
  3,
  1,
  1,
  3,
  5,
  1,
  5,
  1,
  1,
  3,
  1,
  1,
  1,
  1,
  3,
  3,
  1
]

defmodule Day06 do
  def fishes_after(state, 0), do: state

  def fishes_after(state, days) do
    state
    |> Enum.flat_map(&next_fish/1)
    |> fishes_after(days - 1)
  end

  def next_fish(fish) do
    case fish do
      0 -> [6, 8]
      n -> [n - 1]
    end
  end
end

defmodule Day06_Part2 do
  def fishes_after(state, 0) when is_tuple(state), do: state

  def fishes_after(frequencies, days) when is_tuple(frequencies) do
    frequencies
    |> next_frequency
    |> fishes_after(days - 1)
  end

  def fishes_after(state, days) do
    frequencies =
      state
      |> Enum.frequencies()

    Enum.map(0..8, fn i -> frequencies[i] || 0 end)
    |> List.to_tuple()
    |> fishes_after(days)
    |> Tuple.sum()
  end

  def next_frequency({day_0, day_1, day_2, day_3, day_4, day_5, day_6, day_7, day_8}) do
    {day_1, day_2, day_3, day_4, day_5, day_6, day_7 + day_0, day_8, day_0}
  end

  def tests() do
    2 = Day06.fishes_after([6], 7) |> length
    2 = Day06_Part2.fishes_after([6], 7)

    3 = Day06.fishes_after([6], 15) |> length
    3 = Day06_Part2.fishes_after([6], 15)

    5934 = Day06.fishes_after([3, 4, 3, 1, 2], 80) |> length
    5934 = Day06_Part2.fishes_after([3, 4, 3, 1, 2], 80)
  end
end

test_input = [3, 4, 3, 1, 2]

26_984_457_539 = Day06_Part2.fishes_after(test_input, 256)
IO.inspect(Day06_Part2.fishes_after(challenge_input, 256))

# 5934 =
#   Day06_Part2.fishes_after(test_input, 80)
#   |> length

# 26 =
#   Day06_Part2.fishes_after(test_input, 18)
#   |> length

# IO.puts(
#   Day06_Part2.fishes_after(
#     challenge_input,
#     256
#   )
#   |> length
# )
