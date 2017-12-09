defmodule AC.Dec07 do

  # Part 1
  defmodule TreeNode do
    defstruct name: nil, weight: -1, children: []
  end

  def parse_line(line) do
    if line =~ "->" do
      %{"name" => name, "weight" => weight, "children" => children} =
        Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\) -> (?<children>.*)$/, line)
      %TreeNode{
        name: name,
        weight: String.to_integer(weight),
        children: Enum.map(String.split(children, ","), fn(c) -> String.trim(c) end)
      }
    else
      %{"name" => name, "weight" => weight} =
        Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\)$/, line)
      %TreeNode{name: name, weight: String.to_integer(weight)}
    end
  end

  def find_root_in_list(nodes) do
    # For each TreeNode seen:
    #   put the Name in a set of known_nodes
    #   for each child seen, put the put the children's names in a map of known_children
    acc_init = {MapSet.new(), MapSet.new()}
    {known_nodes, known_children} =
      Enum.reduce(nodes, acc_init, fn(node, {known_nodes, known_children}) ->
        {
          MapSet.put(known_nodes, node.name),
          Enum.reduce(node.children, known_children, fn(child, acc) ->
            MapSet.put(acc, child)
          end)
        }
      end)
    # The root is the (only) node that is not a child (set difference
    # known_nodes - known_children)
    # sanity check
    if MapSet.size(known_nodes) - MapSet.size(known_children) != 1 do
      raise "Could not determine the root!  Bug!"
    end
    MapSet.difference(known_nodes, known_children)
    |> MapSet.to_list
    |> hd
  end

  def find_root(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.to_list
    |> find_root_in_list()
  end

  # Part 2

  # starting at "start" find the first (presumably only) child that is
  # unbalanced in "tree"
  def find_unbalanced_node(tree, start) do
    this_node = Map.get(tree, start)
    IO.puts("this_node:")
    IO.inspect(this_node)
    # if I'm balanced (that is, all my children are balanced)
    if Enum.uniq_by(this_node.children, fn(c) ->
      IO.puts("considering #{c}")
      Map.get(tree, c).weight
      end) == 1 do
    #   find_unbalanced_node on each of my children
      Enum.map(this_node.children, fn(c) -> find_unbalanced_node(tree, c) end)
    else
    # if I'm not balanced
    #   return myself (start)
      start
    end
  end

  # one of node's children has an incorrect weight; find it
  def find_erroneous_child(tree, node) do
    IO.puts("find_erroneous_child")
    IO.inspect(node)
    children = Map.get(tree, node).children |> Enum.map(fn(c) -> Map.get(tree, c) end)
    IO.inspect(children)
    # Assume that there must be at least three nodes in order to find the
    # one which is "wrong"
    # Take the first three, add to a frequency map, and pick the value
    # greater than two
    #right
  end

  def find_balance_weight(filename) do
    tree = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce(%{}, fn(node, acc) -> Map.put(acc, node.name, node) end)

    # TODO optimize: don't read the file twice
    root = find_root(filename)

    unbalanced_node = find_unbalanced_node(tree, root)
    find_erroneous_child(tree, unbalanced_node)
  end
end
