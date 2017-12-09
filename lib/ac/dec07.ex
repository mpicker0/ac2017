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

  # for testing only; print out the node and the total weights of its children
  def show_node(tree, node_name) do
    IO.puts("---- Node info for node '#{node_name}' ----")
    node = Map.get(tree, node_name)
    IO.inspect(node)
    IO.puts("total weight: #{total_weight(tree, node)}")
    IO.puts("children:")
    Enum.map(node.children, fn(c) ->
      child = Map.get(tree, c)
      IO.puts("  name: #{child.name}; weight: #{child.weight}; total weight: #{total_weight(tree, child)}")
    end)
    IO.puts("---- end ----")
    node
  end

  # compute the total weight of a node (the weight of the node plus that of its
  # children)
  def total_weight(tree, node) do
    # total weight is weight of this node, plus the weight of all children
    node.children
      |> Enum.map(fn(c) -> total_weight(tree, Map.get(tree, c)) end)
      |> Enum.reduce(node.weight, fn(nw, acc) -> acc + nw end)
  end

  def balanced?(tree, node) do
    # this node is balanced if all the total weights of its children are
    uniques = Enum.uniq_by(node.children, fn(c) ->
      total_weight(tree, Map.get(tree, c))
    end)
    length(uniques) <= 1
  end

  def find_deepest_unbalanced_node(tree, start) do
    this_node = Map.get(tree, start)

    if Enum.all?(this_node.children, fn(c) -> balanced?(tree, Map.get(tree, c)) end) do
      # If all my children are balanced, I must be unbalanced
      start
    else
      # If I have an unbalanced child (presumably just one), follow it down
      unbalanced_child = Enum.find(this_node.children, fn(c) -> !balanced?(tree, Map.get(tree, c)) end)
      find_deepest_unbalanced_node(tree, unbalanced_child)
    end
  end

  # one of node_name's children has an incorrect weight; find the correct
  # value that would make it work
  def find_new_weight(tree, node_name) do
    node = Map.get(tree, node_name)
    children = node.children |> Enum.map(fn(c) -> Map.get(tree, c) end)
    # Assume that there must be at least three nodes in order to find the
    # one which is "wrong"
    correct_value = children
      |> Enum.take(3)
      |> Enum.map(fn(c) -> total_weight(tree, c) end)
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      |> Map.to_list
      |> Enum.find(fn({_, v}) -> v >= 2 end)
      |> elem(0)

    bad_node = children |>
      Enum.find(fn(c) -> total_weight(tree, c) != correct_value end)
    bad_node_total_weight = total_weight(tree, bad_node)
    correct_value - (bad_node_total_weight - bad_node.weight)
  end

  def find_balance_weight(filename) do
    tree = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce(%{}, fn(node, acc) -> Map.put(acc, node.name, node) end)

    # TODO optimize: don't read the file twice
    root = find_root(filename)

    unbalanced_node = find_deepest_unbalanced_node(tree, root)
    find_new_weight(tree, unbalanced_node)
  end

  def test_it(filename) do
    tree = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce(%{}, fn(node, acc) -> Map.put(acc, node.name, node) end)
    Enum.map(tree, fn({k, v}) ->
      IO.puts("node #{k} balanced: #{balanced?(tree, v)}")
    end)
  end
end
