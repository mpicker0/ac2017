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

      pretty_print_state(state)
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
  def find_h_value(filename) do
    state = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
    |> execute_instructions(%State{registers: %{"a" => 1}})
    IO.inspect(state)
    Map.get(state.registers, "h")
  end
end
