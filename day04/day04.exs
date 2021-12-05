defmodule Bingo do
  def read_input(filename) do
    lines =
      filename
      |> File.stream!()
      |> Enum.map(fn line -> line end)

    %{draws: hd(lines)}
  end
end

%{draws: "7,4,9" <> _} = Bingo.read_input("test_input.txt")
