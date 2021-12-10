expected_output = """
.......1..
..1....1..
..1....1..
.......1..
.112111211
..........
..........
..........
..........
222111....
"""

defmodule Day05 do
  def read_input(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split(" -> ")
      |> Enum.map(fn coordinate ->
        coordinate |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
      |> List.to_tuple()
    end)
  end

  def horizontal_or_vertical?({{x, y}, {x2, y2}}) do
    x == x2 || y == y2
  end

  def intermediate_points({{x, y}, {x2, y2}}) do
    Enum.flat_map(x..x2, fn x ->
      Enum.map(y..y2, fn y ->
        {x, y}
      end)
    end)
  end

  def count_intersections(file_name) do
    file_name
    |> read_input()
    |> Enum.filter(&horizontal_or_vertical?/1)
    |> Enum.flat_map(&intermediate_points/1)
    |> Enum.reduce(%{}, fn coordinate, acc ->
      Map.put(acc, coordinate, Map.get(acc, coordinate, 0) + 1)
    end)
    |> Enum.count(fn {_key, value} -> value >= 2 end)
  end
end

5 = Day05.count_intersections("test_input.txt")
IO.inspect(Day05.count_intersections("input.txt"))
