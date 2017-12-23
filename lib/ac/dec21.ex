defmodule AC.Dec21 do

  # Part 1
  @iterations 5
  @starting_state ".#./..#/###"

  # for debugging
  def pretty_print(grid) do
    Enum.map(grid, fn(r) ->
      IO.puts(Enum.join(r))
    end)
    grid
  end

  # input and output are a list of lists
  def rotate_clockwise(grid) do
    grid
      |> Enum.reverse
      |> List.zip
      |> Enum.map(fn(t) -> Tuple.to_list(t) end)
  end

  def flip(grid) do
    grid |> Enum.map(fn(r) -> Enum.reverse(r) end)
  end

  def get_all_rotations(_, rotations, 0), do: rotations
  def get_all_rotations(grid, rotations, remaining) do
    rotated_grid = rotate_clockwise(grid)
    get_all_rotations(rotated_grid, MapSet.put(rotations, rotated_grid), remaining - 1)
  end

  def get_all_versions(grid) do
    rotated = grid |> get_all_rotations(%MapSet{}, 4)
    flipped_rotated = grid |> flip |> get_all_rotations(%MapSet{}, 4)
    MapSet.union(rotated, flipped_rotated)
  end

  # break up an NxN grid (where N is a multiple of size) into a number of
  # size x size grids
  def break_up_grid(in_grid, size) do
    in_grid
    |> Enum.map(fn(g)->Enum.chunk_every(g, size) end)
    |> List.zip
    |> Enum.map(fn(t) -> Tuple.to_list(t) end)
    |> Enum.map(fn(g) -> Enum.chunk_every(g, size) end)
    |> List.zip
    |> Enum.map(fn(t) -> Tuple.to_list(t) end)
  end

  def merge_grids(in_grids) do
    in_grids
    |> Enum.map(fn(l) ->
         List.zip(l) |>
         Enum.map(fn(individual) ->
           Tuple.to_list(individual)
           |> Enum.reduce([], fn(list, acc) -> acc ++ list end)
         end)
       end)
    |> Enum.reduce([], fn(list, acc) -> acc ++ list end)
  end

  # convert a string in the form of ../.# to a list of lists
  def parse_grid(s) do
    String.split(s, "/")
    |> Enum.map(fn(s) -> String.codepoints(s) end)
  end

  # return a keyword list of :in and :out which correspond to the raw input
  # grid and its output.
  def parse_rule(line) do
    %{"in" => in_raw, "out" => out_raw} =
      Regex.named_captures(~r/(?<in>.*) => (?<out>.*)/, line)
    [in: parse_grid(in_raw), out: parse_grid(out_raw)]
  end

  def rule_map(rules) do
    Enum.reduce(rules, %{}, fn(r, acc) ->
      get_all_versions(r[:in])
      |> Enum.reduce(acc, fn(v, acc2) -> Map.put(acc2, v, r[:out]) end)
    end)
  end

  def enhance(rules, pixels) when length(pixels) in [2, 3] do
    Map.get(rules, pixels)
  end
  def enhance(rules, pixels) do
    square_size = if (rem(length(pixels), 2) == 0), do: 2, else: 3
    pieces = break_up_grid(pixels, square_size)
    enhanced = Enum.map(pieces, fn(row) ->
      Enum.map(row, fn(col) -> enhance(rules, col) end)
    end)
    merge_grids(enhanced)
  end

  def iterate_on_pixels(pixels, _, 0), do: pixels
  def iterate_on_pixels(pixels, rules, iterations) do
    new_pixels = enhance(rules, pixels)
    iterate_on_pixels(new_pixels, rules, iterations - 1)
  end

  def count_on_pixels(filename, iterations \\ @iterations, starting_state \\ @starting_state) do
    all_rules = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_rule(line) end)
    |> rule_map

    iterate_on_pixels(parse_grid(starting_state), all_rules, iterations)
    |> List.flatten
    |> Enum.count(fn(p) -> p == "#" end)
  end

end
