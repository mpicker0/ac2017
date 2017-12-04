defmodule AC.Dec03 do

  def even_stream do
    Stream.iterate(0, & &1 + 2)
  end

  def moves do
    import List
    flatten(
      for times <- Enum.to_list(even_stream() |> Enum.take(600)),
      do: duplicate(:l, times) ++ duplicate(:d, times) ++
          duplicate(:r, times + 1) ++ duplicate(:u, times + 1)
    )
  end

  def get_and_log(spiral_map, coords, default) do
    x = elem(coords, 0)
    y = elem(coords, 1)
    IO.puts(:io_lib.format " x: ~B, y: ~B", [x,y])
    Map.get(spiral_map, {x, y}, 0)
  end

  def adjacent_values(spiral_map, coords) do
    IO.puts("-----")
    IO.puts("called adjacent_values with spiral_map of")
    IO.inspect(spiral_map)
    IO.puts("and coords of")
    IO.inspect(coords)
    all_things = for x <- elem(coords, 0) - 1 .. elem(coords, 0) + 1,
        y <- elem(coords, 1) - 1 .. elem(coords, 0) + 1,
        do:
        #Map.get(spiral_map, {x, y}, 0)
        get_and_log(spiral_map, {x, y}, 0)

    all_things
    |> IO.inspect()
    |> Enum.sum
  end

  def coords_from_movement(location) do
    movement_map =
      moves()
      |> Enum.take(location - 1)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    { Map.get(movement_map, :r, 0) - Map.get(movement_map, :l, 0),
      Map.get(movement_map, :u, 0) - Map.get(movement_map, :d, 0) }
  end

  def spiral_values do
    # initial coordinates with respect to origin are {0, 0}
    # first value is 1
    # add coordinates and value to a map:  {0, 0} => 1
    value_map = %{{0, 0} => 1}

    # next coordinates can be calculated based on moves: {1, 0}
    # second value is (sum of all adjacent squares)
    # add coordinates to a map:  {1, 0} =>
    coord_list = for l <- 1..10,  do:
      coords_from_movement(l)

    IO.inspect(coord_list)

    coord_map = coord_list
      |> Enum.reduce(value_map, fn(x, acc) ->
           Map.put(acc, x, adjacent_values(acc, x))
         end)
    #IO.inspect(coord_map)

    coord_list
      |> Enum.map(fn(x) -> Map.get(coord_map, x) end)
      |> IO.inspect
  end

  def sum_at(location) do
    Enum.at(spiral_values(), location - 1)
  end

  # User-facing functions

  def distance_from_origin(location) do
    movement_map =
      moves()
      |> Enum.take(location - 1)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    dist_x = abs(Map.get(movement_map, :r, 0) - Map.get(movement_map, :l, 0))
    dist_y = abs(Map.get(movement_map, :u, 0) - Map.get(movement_map, :d, 0))
    dist_x + dist_y
  end

  def first_greater(num) do
    # Get a list of all the numbers
    # Report back the first one greater than num
    Enum.find(spiral_values(), fn(x) -> x > num end)
  end

end
