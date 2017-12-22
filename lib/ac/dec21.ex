defmodule AC.Dec21 do

  # Part 1
  @iterations 5

  # input and output are a list of lists
  def rotate_clockwise(grid) do
    grid
      |> Enum.reverse
      |> List.zip
      |> Enum.map(fn(t) -> Tuple.to_list(t) end)
  end

  def flip(grid) do
    grid
      |> Enum.map(fn(r) -> Enum.reverse(r) end)
  end

  def get_all_rotations(grid, rotations, 0), do: rotations
  def get_all_rotations(grid, rotations, remaining) do
    rotated_grid = rotate_clockwise(grid)
    get_all_rotations(rotated_grid, MapSet.put(rotations, rotated_grid), remaining - 1)
  end

  def get_all_versions(grid) do
    rotated = grid |> get_all_rotations(%MapSet{}, 4)
    flipped_rotated = grid |> flip |> get_all_rotations(%MapSet{}, 4)
    MapSet.union(rotated, flipped_rotated)
  end

  # return a keyword list of :in and :out which correspond to the raw input
  # grid and its output.
  def parse_rule(line) do
    %{"in" => in_raw, "out" => out_raw} =
      Regex.named_captures(~r/(?<in>.*) => (?<out>.*)/, line)

    in_rule = in_raw
      |> String.split("/")
      |> Enum.map(fn(s) -> String.codepoints(s) end)
    out_rule = out_raw
      |> String.split("/")
      |> Enum.map(fn(s) -> String.codepoints(s) end)
    [in: in_rule, out: out_rule]
  end

  def rule_map(rules) do
    Enum.reduce(rules, %{}, fn(r, acc) ->
      get_all_versions(r[:in])
      |> Enum.reduce(acc, fn(v, acc2) -> Map.put(acc2, v, r[:out]) end)
    end)
  end

  def count_on_pixels(filename, iterations \\ @iterations) do
    all_rules = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_rule(line) end)
    |> rule_map
    |>IO.inspect

    # TODO
    # from the starting state, using the rules, continue iterating until
    # finished with the image

    -1
  end

end
