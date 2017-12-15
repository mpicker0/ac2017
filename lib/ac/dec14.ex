defmodule AC.Dec14 do

  # Return a string of zeroes and ones corresponding to num, an integer between
  # 0 and 255.  No error checking is done.  Will be zero-padded to 8 digits
  def binary_string(num) do
    hd(:io_lib.format "~8.2.0B", [num])
    |> List.flatten
    |> to_string
  end

  # Count the number of binary ones in num, an integer between 0 and 255.  For
  # example, count_ones(7) == 3; count_ones(2) == 1
  def count_ones(num) do
    binary_string(num)
    |> String.codepoints
    |> Enum.reduce(0, fn(b, acc) -> if b == "1", do: acc + 1, else: acc end)
  end

  # Part 1
  def count_used_squares(input) do
    Enum.map(0..127, fn(i) -> "#{input}-#{i}" end)
    |> Enum.map(fn(i) ->
         AC.Dec10.find_hash_binary(i)
         |> Enum.map(fn(b) -> count_ones(b) end)
         |> Enum.sum
       end)
    |> Enum.sum
  end

  # Part 2
  def count_regions(input) do
    -1
  end
end
