defmodule AC.Dec17 do

  @iterations 2017
  @iterations_2 50_000_000

  # Part 1

  # Return a new buffer representing taking "steps" steps forward from position
  # "pos".  "i" is the iteration counter.
  def step_forward(buffer, _, _, i, iterations) when i == iterations, do: buffer
  def step_forward(buffer, steps, pos, i, iterations) do
    if (rem(i, 10_000) == 0) do
      IO.puts("iteration #{i}")
    end
    # i + 1 is a cheap way to get the buffer length
    new_pos = rem(pos + steps, i + 1) + 1
    new_buffer = List.insert_at(buffer, new_pos, i + 1)
    step_forward(new_buffer, steps, new_pos, i + 1, iterations)
  end

  def find_value_after_last(input, iterations \\ @iterations) do
    new_list = step_forward([0], input, 0, 0, iterations)
    idx = Enum.find_index(new_list, fn(b) -> b == 2017 end)
    Enum.at(new_list, idx + 1)
  end

  # Part 2
  def find_value_after_zero(input, iterations \\ @iterations_2) do
    new_list = step_forward([0], input, 0, 0, iterations)
    IO.inspect(new_list)
    idx = Enum.find_index(new_list, fn(b) -> b == 0 end)
    Enum.at(new_list, idx + 1)
  end

end
