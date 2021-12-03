defmodule Submarine do
  def move({horizontal, depth, aim}, "forward", units) do
    {horizontal + units, depth + aim * units, aim}
  end

  def move({horizontal, depth, aim}, "down", units) do
    {horizontal, depth, aim + units}
  end

  def move({horizontal, depth, aim}, "up", units) do
    {horizontal, depth, aim - units}
  end

  def execute_commands(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.split/1)
    |> Enum.reduce({0, 0, 0}, fn [direction, units], acc ->
      move(acc, direction, String.to_integer(units))
    end)
  end
end

{15, 60, _} = Submarine.execute_commands("test_input.txt")

{x, depth, _} = Submarine.execute_commands("input.txt")
IO.puts(x * depth)
