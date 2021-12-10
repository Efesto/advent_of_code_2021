defmodule Bingo do
  @board_size 5
  def calculate_winning(filename) do
    [draws | boards] =
      filename
      |> File.stream!()
      |> Enum.map(&String.trim/1)
      |> Enum.filter(fn line -> line != "" end)

    draws =
      draws
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.map(fn line ->
        line
        |> String.split()
        |> Enum.map(fn number -> {String.to_integer(number), false} end)
      end)
      |> Enum.chunk_every(@board_size)
      |> Enum.map(fn lines -> lines |> Enum.concat() end)

    Enum.reduce_while(draws, boards, fn draw, acc ->
      boards =
        acc
        |> Enum.map(fn board -> mark_draw_on_board(draw, board) end)

      winning_board =
        boards
        |> Enum.find(&board_won?/1)

      if winning_board != nil, do: {:halt, {draw, winning_board}}, else: {:cont, boards}
    end)
    |> calculate_score()
  end

  def mark_draw_on_board(draw, board) do
    board
    |> Enum.map(fn {value, marked} -> {value, marked || value == draw} end)
  end

  def calculate_score({draw, winning_board}) do
    unmarked_sum =
      winning_board
      |> Enum.filter(fn {_, marked} -> !marked end)
      |> Enum.reduce(0, fn {value, _}, acc -> acc + value end)

    unmarked_sum * draw
  end

  def board_won?(board) do
    rows =
      board
      |> Enum.chunk_every(@board_size)

    row_won =
      rows
      |> Enum.any?(fn row ->
        Enum.count(row, fn {_, marked} -> marked == true end) == @board_size
      end)

    column_won =
      Enum.map(0..(@board_size - 1), fn col ->
        Enum.map(0..(@board_size - 1), fn row ->
          Enum.at(board, col + row * @board_size)
        end)
      end)
      |> Enum.any?(fn col ->
        Enum.count(col, fn {_, marked} -> marked == true end) == @board_size
      end)

    row_won || column_won
  end
end

4512 = Bingo.calculate_winning("test_input.txt")

IO.puts(Bingo.calculate_winning("input.txt"))
