defmodule AC.Dec06 do
  import Enum

  # Part 1

  # starting at "start", if I take "steps" steps forward on a circular array
  # of length "length", will I make it to "target"
  def will_reach_target?(start, steps, target, length) do
    if target < start do
      start + steps >= target + length
    else
      start + steps >= target
    end
  end

  def redistribute(initial) do
    memory_cells = length(initial)

    # Find the biggest item, or the first one if there is a tie
    {largest_index, largest} = 0..memory_cells - 1
      |> Stream.zip(initial)
      |> max_by(fn({_, v}) -> v end)

    # Determine how to distribute the memory.  All cells increase by
    # all_increase_by (this may be zero)
    all_increase_by = div(largest, memory_cells)
    # The remainder must be distributed among the remaining cells if they are
    # in range of the largest
    remainder = largest - (all_increase_by * memory_cells)

    # Map over the list
    result = 0..memory_cells - 1
      |> Stream.zip(initial)
      |> map(fn({index, value}) ->
           cond do
             index == largest_index ->
               all_increase_by
             will_reach_target?(largest_index, remainder, index, memory_cells) ->
               value + all_increase_by + 1
             true ->
               value + all_increase_by
           end
         end)
    result
  end

  def cycles_to_loop_r(memory, configurations_seen, iterations) do
    if MapSet.member?(configurations_seen, memory) do
      iterations
    else
      cycles_to_loop_r(redistribute(memory), MapSet.put(configurations_seen, memory), iterations + 1)
    end
  end

  def cycles_to_loop(initial) do
    parsed_initial = String.split(initial)
      |> map(fn(s) -> String.to_integer(s) end)
    cycles_to_loop_r(parsed_initial, MapSet.new, 0)
  end

  # Part 2

end
