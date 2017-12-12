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

  # Collapse pairs of movements; for example, 3 north and 4 south = 1 south
  # Note: this works because there is no overlap
  def collapse_pairs(path) do
    freq_map = list_to_freq_map(path)
    opposites = [[:n, :s], [:nw, :se], [:sw, :ne]]

    changes = for opposite <- opposites,
      pair = Enum.map(opposite, fn(o) -> {o, Map.get(freq_map, o, 0)} end),
      {loser_key, loser_count} = Enum.min_by(pair, fn({_, count}) -> count end, 0),
      {winner_key, winner_count} = Enum.find(pair, fn({item, _}) -> item != loser_key end),
    do:
      %{winner_key => winner_count - loser_count, loser_key => 0}

    Enum.reduce(changes, freq_map, fn(change, acc) ->
      Map.merge(acc, change)
      end)
      |> freq_map_to_list
  end

  defmodule Replacement do
    defstruct pair: [], replacement: nil
  end

  # This could probably replace collapse_pairs; it is similar but has the
  # additional feature of doing a replacement.  I changed the terms "winner"
  # and "loser" to "small" and "large" in this function.
  def collapse_combination_map(map, replacement) do
    pair = Enum.map(replacement.pair, fn(o) -> {o, Map.get(map, o, 0)} end)
    {small_key, small_count} = Enum.min_by(pair, fn({_, count}) -> count end, 0)
    {large_key, large_count} = Enum.find(pair, fn({item, _}) -> item != small_key end)

    change = %{
      large_key => large_count - small_count,
      small_key => 0
    }

    Map.merge(map, change)
      |> Map.update(replacement.replacement, small_count, fn(v) -> v + small_count end)
  end

  def collapse_combinations(path) do
    freq_map = list_to_freq_map(path)
    replacements = [
      %Replacement{pair: [:ne, :s], replacement: :se},
      %Replacement{pair: [:nw, :s], replacement: :sw},
      %Replacement{pair: [:sw, :n], replacement: :nw},
      %Replacement{pair: [:se, :n], replacement: :ne},
      %Replacement{pair: [:se, :sw], replacement: :s},
      %Replacement{pair: [:ne, :nw], replacement: :n}]

     Enum.reduce(replacements, freq_map, fn(x, acc) -> collapse_combination_map(acc, x) end)
      |> freq_map_to_list
  end

  def find_steps(path) do
    path
      |> collapse_pairs
      |> collapse_combinations
      |> length
  end

  def find_steps_s(path) do
    path
      |> String.split(",")
      |> Enum.map(fn(s) -> String.to_atom(s) end)
      |> find_steps
  end

  def find_steps_in_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
    |> hd
    |> find_steps_s
  end

  # Part 2

  def find_furthest_steps(path) do
    # Basically, start with the first step and compute the length, the second
    # step and compute the length, etc.  Find the max.
    steps = path
      |> String.split(",")
      |> Enum.map(fn(s) -> String.to_atom(s) end)

    lengths = for this_length <- 1..length(steps),
      this_piece = Enum.take(steps, this_length),
      steps = find_steps(this_piece),
    do:
      steps
    Enum.max(lengths)
  end

  def find_furthest_steps_in_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
    |> hd
    |> find_furthest_steps
  end
end
