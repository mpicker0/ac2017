defmodule AC.Dec23 do

  # Part 1
  defmodule State do
    defstruct registers: %{}, ip: 0, mul_count: 0
  end

  def get_numeric_operand(operand, state), do: AC.Dec18.get_numeric_operand(operand, state)

  # for debugging
  def pretty_print_state(state) do
    IO.puts("ip: #{state.ip}  a: #{get_numeric_operand("a", state)} " <>
    "b: #{get_numeric_operand("b", state)} " <>
    "c: #{get_numeric_operand("c", state)} " <>
    "d: #{get_numeric_operand("d", state)} " <>
    "e: #{get_numeric_operand("e", state)} " <>
    "f: #{get_numeric_operand("f", state)} " <>
    "g: #{get_numeric_operand("g", state)} " <>
    "h: #{get_numeric_operand("h", state)} "
    )
  end

  def execute_instructions(instructions, state) do
    if (state.ip < 0 or state.ip >= length(instructions)) do
      state
    else
      [instruction | operands] = Enum.at(instructions, state.ip)
        |> String.split

      new_state = case instruction do
        "set" ->
          [dst, val] = operands
          value = get_numeric_operand(val, state)
          %{state | registers: Map.put(state.registers, dst, value), ip: state.ip + 1}
        "add" ->
          [dst, amt] = operands
          curr = Map.get(state.registers, dst, 0)
          amount = get_numeric_operand(amt, state)
          %{state | registers: Map.put(state.registers, dst, curr + amount), ip: state.ip + 1}
        "sub" ->
          [dst, amt] = operands
          curr = Map.get(state.registers, dst, 0)
          amount = get_numeric_operand(amt, state)
          %{state | registers: Map.put(state.registers, dst, curr - amount), ip: state.ip + 1}
        "mul" ->
          [dst, amt] = operands
          curr = Map.get(state.registers, dst, 0)
          amount = get_numeric_operand(amt, state)
          %{state | registers: Map.put(state.registers, dst, curr * amount), ip: state.ip + 1, mul_count: state.mul_count + 1}
        "jnz" ->
          [test, amt] = operands
          amount = get_numeric_operand(amt, state)
          test_value = get_numeric_operand(test, state)
          if (test_value != 0), do: %{state | ip: state.ip + amount}, else: %{state | ip: state.ip + 1}
      end

      execute_instructions(instructions, new_state)
    end
  end

  def count_mul_instructions(filename) do
    state = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
    |> execute_instructions(%State{})
    state.mul_count
  end

  # Part 2
  def not_prime(n) do
    # a number is not prime if it has factors other than 1 and itself
    # check for divisibility by everything from 2 .. sqrt(number)
    Enum.any?(2..round(:math.sqrt(n)), fn(i) -> rem(n, i) == 0 end)
  end

  def step_stream(start, finish, skip) do
    Stream.unfold(start, fn(x) ->
      {x, x + skip}
    end)
    |> Stream.take_while(fn(x) -> x <= finish end)
  end

  def find_h_value() do
    # TODO remove hardcoding (or is that part of the optimization ;) )
    lower_bound = 105700
    upper_bound = 122700
    skip = 17

    Enum.count(step_stream(lower_bound, upper_bound, skip), fn(n) ->
      not_prime(n)
    end)
  end
end
