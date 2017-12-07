defmodule AC.Dec07 do

  # Part 1
  defmodule TreeNode do
    defstruct name: nil, weight: -1, children: nil
  end

  def parse_line(line) do
    if line =~ "->" do
      %{"name" => name, "weight" => weight, "children" => children} =
        Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\) -> (?<children>.*)$/, line)
      %TreeNode{name: name, weight: String.to_integer(weight), children: children}
    else
      %{"name" => name, "weight" => weight} =
        Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\)$/, line)
      %TreeNode{name: name, weight: String.to_integer(weight)}
    end
  end

  def process_node(node) do
    IO.inspect(node)
  end

  def find_root_in_list(nodes) do
    # For each TreeNode seen:
    #   put the Name in a set of known_nodes
    #   for each child seen, put the put the children's names in a map of known_children
    # The root is the (only) node that is not a child (set difference known_nodes - known_children)
    acc_init = {MapSet.new(), MapSet.new()}
    {known_nodes, known_children} =
      #nodes
      #|> Enum.map(fn(node) -> process_node(node) end)
      Enum.reduce(nodes, acc_init, fn(node, acc) ->
        #MapSet.put(known_nodes, node.name)
        #MapSet.put(known_children, "TODO")
        IO.puts("considering node #{node.name} with children #{node.children}")
        # TODO why can't I pattern match these?
        known_nodes = elem(acc, 0)
        known_children = elem(acc, 1)

        # TODO iterate over the children and put them all in (another reduce)
        {MapSet.put(known_nodes, node.name), MapSet.put(known_children, "known child seen")}
      end)
      IO.inspect(known_nodes)
      IO.inspect(known_children)
  end

  def find_root(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.to_list
    |> find_root_in_list()
  end
end
