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
  defmodule Coord do
    defstruct x: nil, y: nil
  end

  defmodule State do
    defstruct grid: nil, regions: 0
  end

  def coord_neighbors(coord) do
    [ %Coord{x: coord.x    , y: coord.y - 1},
      %Coord{x: coord.x    , y: coord.y + 1},
      %Coord{x: coord.x - 1, y: coord.y    },
      %Coord{x: coord.x + 1, y: coord.y    } ]
  end

  def build_grid(input) do
    Enum.map(0..127, fn(i) -> "#{input}-#{i}" end)
    |> Enum.with_index
    |> Enum.map(fn({line, y}) ->
         AC.Dec10.find_hash_binary(line)
         |> Enum.map(fn(s) -> binary_string(s) end)
         |> Enum.join
         |> String.codepoints
         |> Enum.map(fn(b) -> if b == "1", do: :used, else: :free end)
         |> Enum.with_index
         |> Enum.map(fn({b, x}) -> {%Coord{x: x, y: y}, b} end)
       end)
    |> List.flatten
    |> Enum.reduce(%{}, fn({k, v}, acc) -> Map.put(acc, k, v) end)
  end

  def mark_neighbors_r(grid, []) do
    grid
  end

  def mark_neighbors_r(grid, [coord | tail]) do
    # mark this coord
    updated_grid = Map.put(grid, coord, :visited)
    neighbors = coord_neighbors(coord)
    |> Enum.filter(fn(coord) -> Map.get(grid, coord) == :used end)
    mark_neighbors_r(updated_grid, neighbors ++ tail)
  end

  def mark_neighbors(grid, coord) do
    mark_neighbors_r(grid, [coord])
  end

  def visit_coordinate(state, coord) do
    new_state =
    case Map.get(state.grid, coord) do
      :visited ->
        state
      :free ->
        new_grid = Map.put(state.grid, coord, :visited)
        %State{grid: new_grid, regions: state.regions}
      :used ->
        # this is the first time we encountered a used block in this group
        marked_grid = mark_neighbors(state.grid, coord)
        new_grid = Map.put(marked_grid, coord, :visited)
        %State{grid: new_grid, regions: state.regions + 1}
    end
    new_state
  end

  def mark_grid(input) do
    state = %State{grid: input, regions: 0}
    Enum.reduce(Map.keys(input), state, fn(c, acc) -> visit_coordinate(acc, c) end)
  end

  def count_regions(input) do
    result = build_grid(input)
    |> mark_grid
    result.regions
  end

end
