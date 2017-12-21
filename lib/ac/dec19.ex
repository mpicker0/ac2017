defmodule AC.Dec19 do

  defmodule Coord do
    defstruct x: nil, y: nil
  end

  # Part 1
  def parse_grid(filename) do
    File.stream!(filename)
    |> Enum.with_index
    |> Stream.map(fn({s, y}) ->
         String.replace(s, "\n", "")
         |> String.codepoints
         |> Enum.with_index
         |> Enum.map(fn({b, x}) -> {%Coord{x: x, y: y}, b} end)
       end)
    |> Enum.to_list
    |> List.flatten
    |> Enum.reduce(%{}, fn({k, v}, acc) -> Map.put(acc, k, v) end)
  end

  # Find the starting point on the grid.  This is assumed to be the first
  # | character in the top row (probably the only character in the row)
  def find_start(grid) do
    {coord, _} = Enum.find(grid, fn({coord, char}) ->
      coord.y == 0 and char == "|"
    end)
    coord
  end

  def move_coord(coord, direction) do
    case direction do
      :right -> %Coord{coord | x: coord.x + 1}
      :left  -> %Coord{coord | x: coord.x - 1}
      :up    -> %Coord{coord | y: coord.y - 1}
      :down  -> %Coord{coord | y: coord.y + 1}
    end
  end

  def new_direction(grid, coord, current_direction) do
    # if my current_direction is vertical, look for the non-space in the horizontal direction
    # or vice versa
    case current_direction do
      curr when curr in [:up, :down] ->
        if Map.get(grid, move_coord(coord, :left), " ") != " " do
          :left
        else
          :right
        end
      curr when curr in [:left, :right] ->
        if Map.get(grid, move_coord(coord, :up), " ") != " " do
          :up
        else
          :down
        end
    end
  end

  # added count for part 2
  def walk_path(grid, coord, direction, seen \\ [], count \\ 0) do
    # evaluate where we're standing
    this_char = Map.get(grid, coord, " ")
    case this_char do
      " " ->
        [seen: seen, count: count]
      "+" ->
        new_dir = new_direction(grid, coord, direction)
        new_coord = move_coord(coord, new_dir)
        walk_path(grid, new_coord, new_dir, seen, count + 1)
      c ->
        new_coord = move_coord(coord, direction)
        new_seen = if (Regex.match?(~r/[A-Za-z]/, c)), do: seen ++ [c], else: seen
        walk_path(grid, new_coord, direction, new_seen, count + 1)
    end
  end

  def find_path(filename) do
    grid = parse_grid(filename)
    start = find_start(grid)
    walk_path(grid, start, :down)[:seen]
    |> Enum.join
  end

  # Part 2

  def count_steps(filename) do
    grid = parse_grid(filename)
    start = find_start(grid)
    walk_path(grid, start, :down)[:count]
  end

end
