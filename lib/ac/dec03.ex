defmodule AC.Dec03 do
  import Enum

  def even_stream do
    Stream.iterate(0, & &1 + 2)
  end

  def moves do
    import List
    flatten(
      for times <- to_list(even_stream() |> take(600)),
      do: duplicate(:l, times) ++ duplicate(:d, times) ++
          duplicate(:r, times + 1) ++ duplicate(:u, times + 1)
    )
  end

  def adjacent_values(spiral_map, coords) do
    all_things = for x <- elem(coords, 0) - 1 .. elem(coords, 0) + 1,
        y <- elem(coords, 1) - 1 .. elem(coords, 1) + 1,
        do:
        Map.get(spiral_map, {x, y}, 0)

    all_things
    |> sum
  end

  def coords_from_movement(location) do
    movement_map =
      moves()
      |> take(location - 1)
      |> reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
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
    # TODO git rid of this horrible hardcoded thing and use a stream
    # Use 1000 for the real thing, 25 for testing
    coord_list = for l <- 1..1000,  do:
      coords_from_movement(l)

    coord_map = coord_list
      |> reduce(value_map, fn(x, acc) ->
           Map.put(acc, x, adjacent_values(acc, x))
         end)

    coord_list
      |> map(fn(x) -> Map.get(coord_map, x) end)
  end

  def sum_at(location) do
    at(spiral_values(), location - 1)
  end

  # User-facing functions

  def distance_from_origin(location) do
    movement_map =
      moves()
      |> take(location - 1)
      |> reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

    dist_x = abs(Map.get(movement_map, :r, 0) - Map.get(movement_map, :l, 0))
    dist_y = abs(Map.get(movement_map, :u, 0) - Map.get(movement_map, :d, 0))
    dist_x + dist_y
  end

  def first_greater(num) do
    # Get a list of all the numbers
    # Report back the first one greater than num
    find(spiral_values(), fn(x) -> x > num end)
  end

end
