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

  # base case: return a set of visited neighbors
  def visit_neighbors(_, already_visited, []) do
    already_visited
  end

  def visit_neighbors(all_programs, already_visited, programs) do
    # want to visit all children of programs we haven't already seen
    to_visit = Enum.map(programs, fn(p) -> Map.get(all_programs, p) end) |> List.flatten
    filtered = Enum.filter(to_visit, fn(n) -> !MapSet.member?(already_visited, n) end)
    new_already_visited = Enum.reduce(filtered, already_visited, fn(n, acc) -> MapSet.put(acc, n) end)
    visit_neighbors(all_programs, new_already_visited, filtered)
  end

  def get_list_of_programs(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce(%{}, fn(il, acc) ->
         Map.put(acc, il.program, il.neighbors)
       end)
  end

  def how_many_programs_in_input(filename) do
    get_list_of_programs(filename)
    |> visit_neighbors(MapSet.new, [0])
    |> MapSet.size
  end

  # Part 2

  def get_group_count(program_map, count) when program_map == %{} do
    count
  end

  def get_group_count(program_map, count) do
    next_group = visit_neighbors(program_map, MapSet.new, [elem(hd(Map.to_list(program_map)), 0)])
    Map.drop(program_map, MapSet.to_list(next_group))
    |> get_group_count(count + 1)
  end

  def how_many_groups_in_input(filename) do
    get_list_of_programs(filename)
    |> get_group_count(0)
  end

  # Idea:
  # Start with the list of all_programs
  # visit_neighbors against the head item
  # remove everything from the list of programs that appears in the result
  # keep going until the list is empty
end
