defmodule AC.Dec03 do

  def even_stream() do
    Stream.iterate(0, & &1 + 2)
  end

  def sum_at(location) do
    location
  end

  # User-facing functions

  def distance_from_origin(location) do
    import List
    result = flatten(
      for times <- Enum.to_list(even_stream() |> Enum.take(600)),
      do: duplicate(:l, times) ++ duplicate(:d, times) ++
          duplicate(:r, times + 1) ++ duplicate(:u, times + 1)
    )

    movement =
      result
      |> Enum.take(location - 1)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

     dist_x = abs(Map.get(movement, :r, 0) - Map.get(movement, :l, 0))
     dist_y = abs(Map.get(movement, :u, 0) - Map.get(movement, :d, 0))
     dist_x + dist_y
  end

  def first_greater(num) do
    num
  end

end
