defmodule AC.Dec19 do

  defmodule Coord do
    defstruct x: nil, y: nil
  end

  # Part 1
  def parse_grid(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.with_index
    |> Stream.map(fn({s, y}) ->
         String.codepoints(s)
         |> Enum.with_index
         |> Enum.map(fn({b, x}) -> {%Coord{x: x, y: y}, b} end)
       end)
    |> Enum.to_list
    |> List.flatten
    |> Enum.reduce(%{}, fn({k, v}, acc) -> Map.put(acc, k, v) end)
  end

  def find_path(filename) do
    "ABCDEF" # TODO implement
  end

end
