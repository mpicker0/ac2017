defmodule AC.Dec12 do

  # Part 1
  defmodule InputLine do
    defstruct program: nil, neighbors: []
  end

  def parse_line(line) do
    %{"program" => program, "neighbors" => neighbors} =
      Regex.named_captures(~r/(?<program>\d+) <-> (?<neighbors>.*)$/, line)
    %InputLine{
      program: String.to_integer(program),
      neighbors: Enum.map(String.split(neighbors, ","), fn(c) ->
        String.trim(c) |> String.to_integer
      end)
    }
  end

  # returns :true if map contains any of the items in items
  def contains_any_of?(map, items) do
    items
    |> Enum.map(fn(i) -> MapSet.member?(map, i) end)
    |> Enum.any?()
  end

  def how_many_programs_in_input(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce([], fn(il, acc) ->
         #IO.inspect(il)
         IO.puts("-- evaluating whether anything contains #{il.program}")
         IO.puts("acc is:")
         IO.inspect(acc)
         IO.puts("il is:")
         IO.inspect(il)
         # Choose a set to operate on
         {updated_list, program_group} = cond do
           # Does any set in acc contain il.program?
           Enum.any?(acc, fn(group) -> MapSet.member?(group, il.program) end) ->
             IO.puts("1. Some set contains #{il.program}")
             idx = Enum.find_index(acc, fn(group) -> MapSet.member?(group, il.program) end)
             updated_group = Enum.fetch!(acc, idx) |> MapSet.put(il.program)
             IO.puts("1. Updated group:")
             IO.inspect(updated_group)
             IO.puts("1. Adding these neighbors to group:")
             IO.inspect(il.neighbors)
             updated_group_with_neighbors = Enum.reduce(il.neighbors, updated_group, fn(n, acc) ->
               MapSet.put(acc, n)
             end)
             IO.puts("1. updated_group_with_neighbors")
             IO.inspect(updated_group_with_neighbors)
             {List.delete_at(acc, idx), updated_group_with_neighbors}

           # If not, does any set in acc contain any of il.neighbors?
           Enum.any?(acc, fn(group) -> MapSet.member?(group, il.program) end) ->
             IO.puts("2. Some set contains neighbors of #{il.program}")
             idx = Enum.find_index(acc, fn(group) -> MapSet.member?(group, il.program) end)
             updated_group = Enum.fetch!(acc, idx) |> MapSet.put(il.program)
             updated_group_with_neighbors = Enum.reduce(il.neighbors, updated_group, fn(n, acc) ->
               MapSet.put(List.delete_at(acc, idx), n)
             end)
             {List.delete_at(acc, idx), updated_group_with_neighbors}
           #   In either of the two cases above, remove the item so it can be
           #   added back
           # If not, create a new set
           true ->
             IO.puts("3. Nothing contains #{il.program}; neighbors:")
             IO.inspect(il.neighbors)
             updated_group = Enum.reduce([il.program | il.neighbors], MapSet.new, fn(n, acc) -> MapSet.put(acc, n) end)
             {acc, updated_group}
         end

         #
         # Add this program and its neighbors to the set
         # Add the new/updated set back to acc
         IO.puts("updated_list and program_group:")
         IO.inspect(updated_list)
         IO.inspect(program_group)
         [program_group | updated_list]
       end)
    |> IO.inspect

    -1
  end

end
