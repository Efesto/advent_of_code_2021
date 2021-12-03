defmodule Submarine do
  use Bitwise

  def calculate_power_consumption(filename) do
    data_report =
      filename
      |> File.stream!()
      |> Enum.map(fn data_line ->
        data_line |> String.trim() |> String.to_charlist()
      end)

    {calculate_gamma_rate(data_report), calculate_epsilon_rate(data_report)}
  end

  def calculate_gamma_rate(data) do
    word_size = hd(data) |> Enum.count()

    0..(word_size - 1)
    |> Enum.map(fn position -> most_common_bit(data, position) end)
    |> Enum.reverse()
    |> word_to_integer()
  end

  def calculate_epsilon_rate(data) do
    word_size = hd(data) |> Enum.count()

    0..(word_size - 1)
    |> Enum.map(fn position -> least_common_bit(data, position) end)
    |> Enum.reverse()
    |> word_to_integer()
  end

  def most_common_bit(data, position) do
    case Enum.count(data, fn value ->
           (value |> word_to_integer &&& Integer.pow(2, position)) >= 1
         end) > Enum.count(data) / 2 do
      true -> 1
      false -> 0
    end
  end

  def least_common_bit(data, position) do
    case Enum.count(data, fn value ->
           (value |> word_to_integer &&& Integer.pow(2, position)) >= 1
         end) > Enum.count(data) / 2 do
      true -> 0
      false -> 1
    end
  end

  def word_to_integer(word) do
    word_size = Enum.count(word)

    <<integer::size(word_size)>> =
      Enum.into(word, <<>>, fn bit ->
        <<bit::1>>
      end)

    integer
  end
end

{22, 9} = Submarine.calculate_power_consumption("test_input.txt")
{2027, 2068} = Submarine.calculate_power_consumption("test_input2.txt")

{gamma, epsilon} = Submarine.calculate_power_consumption("input.txt")
IO.puts(gamma * epsilon)

# TODO: https://adventofcode.com/2021/day/3#part2
