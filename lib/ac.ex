defmodule AC do
  def string_to_ints(string) do
    import String
    split(string) |> Enum.map(fn(s) -> to_integer(s) end)
  end
end
