defmodule AC.Dec16 do

  @initial_state String.codepoints("abcdefghijklmnop")
  @iterations 1_000_000_000

  # Part 1

  # Doesn't work right if programs > length(list); this should never happen
  def spin(list, 0), do: list
  def spin(list, program_count) do
    len = length(list)
    last = Enum.slice(list, -program_count..-1)
    first = Enum.slice(list, 0..(len-program_count)-1)
    last ++ first
  end

  def exchange(list, a, b) do
    program_a = Enum.at(list, a)
    program_b = Enum.at(list, b)
    list |> List.replace_at(a, program_b) |> List.replace_at(b, program_a)
  end

  def partner(list, a, b) do
    pos_a = Enum.find_index(list, fn(p) -> p == a end)
    pos_b = Enum.find_index(list, fn(p) -> p == b end)
    list |> exchange(pos_a, pos_b)
  end

  def run_instructions([], list), do: list
  def run_instructions([curr_inst | tail], list) do
    new_list = case String.slice(curr_inst, 0, 1) do
      "s" ->
        # s1
        spin(list, String.to_integer(String.slice(curr_inst, 1, 999)))
      "x" ->
        # x3/4
        [a, b] = String.slice(curr_inst, 1, 999)
                 |> String.split("/")
                 |> Enum.map(fn(n) -> String.to_integer(n) end)
        exchange(list, a, b)
      "p" ->
        # pe/b
        [a, b] = String.slice(curr_inst, 1, 999) |> String.split("/")
        partner(list, a, b)
      _ ->
        IO.puts("ERROR!  Unexpected input: #{curr_inst}")
        list
    end
    run_instructions(tail, new_list)
  end

  def get_instructions(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
    |> hd
    |> String.split(",")
  end

  def final_state(filename, initial_state \\ @initial_state) do
    get_instructions(filename)
    |> run_instructions(initial_state)
    |> Enum.join
  end

  # Part 2
  def run_instructions_r(_, list, 0) do
    list
  end
  def run_instructions_r(instructions, list, iterations) do
    new_list = run_instructions(instructions, list)
    run_instructions_r(instructions, new_list, iterations - 1)
  end

  # return the repeated item and the first and last index of where it occurred
  def find_cycle(instructions, list, seen, step) do
    new_list = run_instructions(instructions, list)
    if (Map.has_key?(seen, list)) do
      {Map.get(seen, list), Map.size(seen)}
    else
      find_cycle(instructions, new_list, Map.put(seen, list, step), step + 1)
    end
  end

  def final_state_2(filename, initial_state \\ @initial_state, iterations \\ @iterations) do
    instructions = get_instructions(filename)
    {first_index, repeated_index} =
      find_cycle(instructions, initial_state, %{}, 0)

    short_iterations = rem(iterations, repeated_index - first_index)
    run_instructions_r(instructions, initial_state, short_iterations)
  end

  # testing
  def has_loop_r([], _), do: :false
  def has_loop_r([h|t], seen) do
    if (MapSet.member?(seen, h)) do
      :true
    else
      has_loop_r(t, MapSet.put(seen, h))
    end
  end
  #
  def has_loop(list) do
    has_loop_r(list, %MapSet{})
  end

  def loop_start_r([h|t], seen) do
    if (MapSet.member?(seen, h)) do
      MapSet.size(seen)
    else
      loop_start_r(t, MapSet.put(seen, h))
    end
  end
  # loop_start finds the index of the first node that is a repeat
  def loop_start(list) do
    loop_start_r(list, %MapSet{})
  end

  #
  def loop_length(list) do
    # find the loop_start; this is the second time we saw that node
    first_repeated_index = loop_start(list)
    first_repeated_item = Enum.at(list, first_repeated_index)
    # now, determine the first time that node appears
    first_index = Enum.find(list, fn(n) -> n == first_repeated_item end)
    first_repeated_index - first_index
  end
end
