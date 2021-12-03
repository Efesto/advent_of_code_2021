defmodule Submarine do
  def move({horizontal, depth}, "forward", units) do
    {horizontal + units, depth}
  end

  def move({horizontal, depth}, "down", units) do
    {horizontal, depth + units}
  end

  def move({horizontal, depth}, "up", units) do
    {horizontal, depth - units}
  end

  def execute_commands(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.split/1)
    |> Enum.reduce({0, 0}, fn [direction, units], acc ->
      move(acc, direction, String.to_integer(units))
    end)
  end
end

{15, 10} = Submarine.execute_commands("test_input.txt")

{x, depth} = Submarine.execute_commands("input.txt")
IO.puts(x * depth)
