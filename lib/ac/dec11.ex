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

  def collapse_pairs(path) do
    freq_map = list_to_freq_map(path)

    opposites = [[:n, :s], [:nw, :se], [:sw, :ne]]
    for opposite <- opposites,
      pair = Map.take(freq_map, opposite) |> Map.to_list,
      # IO.puts("pair:"),
      # IO.inspect(pair),
      {loser_key, loser_count} = Enum.min_by(pair, fn({item, count}) -> count end, 0),
      #{{loser_key, loser_count}, {winner_key, winner_count}} = Enum.min_max_by(pair, fn({item, count}) -> count end, 0),
      {winner_key, winner_count} = Enum.find(pair, fn({item, count}) -> item != loser_key end),

      # IO.puts("winner and loser:"),
      # IO.inspect(winner_key),
      # IO.inspect(loser_key),
      updated_winner_count = winner_count - loser_count,
      #updated_loser_count = 0

      updated_map = freq_map
        |> Map.put(winner_key, updated_winner_count)
        |> Map.put(loser_key, 0)
        |> IO.inspect,
      into: freq_map,
      do:
        updated_map



    # Remove the (set it to zero); replace the winner with the difference
  end

  def find_steps(path) do
    IO.puts(path)
    -1
  end
end
