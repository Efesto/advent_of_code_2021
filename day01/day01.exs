defmodule Increments do
  def count(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(fn x ->
      {value, _} = Integer.parse(x)
      value
    end)
    |> Stream.chunk_every(3, 1)
    |> Enum.map(&Enum.sum/1)
    |> Stream.chunk_every(2, 1)
    |> Enum.filter(fn measure -> Enum.count(measure) > 1 end)
    |> Enum.count(fn [measure_1, measure_2] ->
      measure_1 < measure_2
    end)
  end
end

5 = Increments.count("test_input.txt")

IO.puts(Increments.count("input.txt"))
