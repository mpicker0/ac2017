defmodule AC do
  def string_to_ints(string) do
    import String
    split(string) |> Enum.map(fn(s) -> to_integer(s) end)
  end

  def list_to_freq_map(list) do
    list
      |> Enum.reduce(%{}, fn(x, acc) ->
           Map.update(acc, x, 1, fn(x) -> x + 1 end)
         end)
  end
end
