defmodule Increments do
  def count(file_name) do
    file_name
    |> File.stream!()
    |> Stream.chunk_every(2, 1)
    |> Enum.filter(fn measure -> Enum.count(measure) > 1 end)
    |> Enum.count(fn [measure_1, measure_2] ->
      Integer.parse(measure_1) < Integer.parse(measure_2)
    end)
  end
end

7 = Increments.count("test_input.txt")

IO.puts(Increments.count("input.txt"))
