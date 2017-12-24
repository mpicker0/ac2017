defmodule AC.Dec24 do

  # Part 1
  defmodule Component do
    defstruct ports: []
  end

  def free_end(list, connection \\ 0)
  def free_end([h], connection) do
    [res] = List.delete(h.ports, connection)
    res
  end
  def free_end([h|t], connection) do
    free_end(t, free_end([h], connection))
  end

  # current_bridge is the bridge assembled so far
  # components is the list of remaining components
  def build_bridge(current_bridge, components) do
    free_end = free_end(current_bridge)
    components_that_fit = Enum.filter(components, fn(c) ->
      free_end in c.ports
    end)

    if (components_that_fit == []) do
      [current_bridge]
    else
      # recurse for all the components that connect to this one
      Enum.flat_map(components_that_fit, fn(c) ->
        build_bridge(current_bridge ++ [c], List.delete(components, c))
      end)
    end
  end

  def build_bridge_start(components) do
    # call build_bridge for each zero component
    Enum.filter(components, fn(c) -> 0 in c.ports end)
    |> Enum.flat_map(fn(c) ->
         build_bridge([c], List.delete(components, c))
       end)
  end

  def bridge_strength(bridge) do
    Enum.reduce(bridge, 0, fn(c, acc) ->
      acc + Enum.sum(c.ports)
    end)
  end

  def find_strongest_bridge(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) ->
         ports = String.split(line, "/") |> Enum.map(&String.to_integer/1)
         %Component{ports: ports}
       end)
    |> Enum.to_list
    |> build_bridge_start
    |> Enum.map(fn(b) -> bridge_strength(b) end)
    |> Enum.max
  end

end
