defmodule Submarine do
  use Bitwise

  def calculate_power_consumption(filename) do
    data_report = get_data_report(filename)
    {calculate_gamma_rate(data_report), calculate_epsilon_rate(data_report)}
  end

  def get_data_report(filename) do
    filename
    |> File.stream!()
    |> Enum.map(fn data_line ->
      data_line |> String.trim() |> String.to_charlist()
    end)
  end

  def calculate_o2_and_co2(filename) do
    data_report = get_data_report(filename)
    {calculate_oxygen_generator_rating(data_report), calculate_co2_scrubber_rating(data_report)}
  end

  def calculate_oxygen_generator_rating(data) do
    word_size = hd(data) |> Enum.count()

    (word_size - 1)..0
    |> Enum.reduce(data, fn position, data ->
      bit = most_common_bit(data, position)

      Enum.filter(data, fn word ->
        <<Enum.at(word |> Enum.reverse(), position)>> == "#{bit}"
      end)
    end)
    |> hd
    |> word_to_integer()
  end

  def calculate_co2_scrubber_rating(data) do
    word_size = hd(data) |> Enum.count()

    (word_size - 1)..0
    |> Enum.reduce(data, fn position, data ->
      bit = least_common_bit(data, position)

      if Enum.count(data) > 1 do
        Enum.filter(data, fn word ->
          <<Enum.at(word |> Enum.reverse(), position)>> == "#{bit}"
        end)
      else
        data
      end
    end)
    |> hd
    |> word_to_integer()
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
         end) >= Enum.count(data) / 2 do
      true -> 1
      false -> 0
    end
  end

  def least_common_bit(data, position) do
    case Enum.count(data, fn value ->
           (value |> word_to_integer &&& Integer.pow(2, position)) >= 1
         end) >= Enum.count(data) / 2 do
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

{23, 10} = Submarine.calculate_o2_and_co2("test_input.txt")
{o2, co2} = Submarine.calculate_o2_and_co2("input.txt")
IO.puts(o2 * co2)
