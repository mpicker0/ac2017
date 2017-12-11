defmodule AC.Dec11 do

  # Part 1
  def list_to_freq_map(list) do
    list
      |> Enum.reduce(%{}, fn(x, acc) ->
           Map.update(acc, x, 1, fn(x) -> x + 1 end)
         end)
  end

  def freq_map_to_list(map) do
    map
      |> Enum.to_list
      |> Enum.map(fn({item, count}) -> List.duplicate(item, count) end)
      |> List.flatten
  end

  def find_steps(path) do
    IO.puts(path)
    -1
  end
end
