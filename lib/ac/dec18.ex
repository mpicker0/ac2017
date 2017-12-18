defmodule AC.Dec18 do

  defmodule State do
    defstruct registers: %{}, ip: 0, last_played: nil, last_recovered: nil, terminate: :false
  end

  # Part 1
  def get_numeric_operand(operand, state) do
    case Integer.parse(operand) do
      {i, _} -> i
      :error -> Map.get(state.registers, operand, "0")
    end
  end

  def execute_instructions(instructions, state) do
    if (state.ip < 0 or state.ip >= length(instructions) or state.terminate == :true) do
      state
    else
      [instruction | operands] = Enum.at(instructions, state.ip)
        |> String.split
      # TODO refactor to remove common code
      new_state = case instruction do
        "snd" ->
          [register] = operands
          played = Map.get(state.registers, register, 0)
          %{state | last_played: played, ip: state.ip + 1}
        "set" ->
          [dst, val] = operands
          value = get_numeric_operand(val, state)
          %{state | registers: Map.put(state.registers, dst, value), ip: state.ip + 1}
        "add" ->
          [dst, amt] = operands
          curr = Map.get(state.registers, dst, 0)
          amount = get_numeric_operand(amt, state)
          %{state | registers: Map.put(state.registers, dst, curr + amount), ip: state.ip + 1}
        "mul" ->
          [dst, amt] = operands
          curr = Map.get(state.registers, dst, 0)
          amount = get_numeric_operand(amt, state)
          %{state | registers: Map.put(state.registers, dst, curr * amount), ip: state.ip + 1}
        "mod" ->
          [dst, div] = operands
          value1 = Map.get(state.registers, dst, 0)
          divisor = get_numeric_operand(div, state)
          %{state | registers: Map.put(state.registers, dst, rem(value1, divisor)), ip: state.ip + 1}
        "rcv" ->
          [register] = operands
          value = Map.get(state.registers, register, 0)
          if (value == 0), do: %{state | ip: state.ip + 1}, else: %{state | ip: state.ip + 1, last_recovered: state.last_played, terminate: :true}
        "jgz" ->
          [test, amt] = operands
          amount = get_numeric_operand(amt, state)
          test_value = Map.get(state.registers, test, 0)
          if (test_value > 0), do: %{state | ip: state.ip + amount}, else: %{state | ip: state.ip + 1}
      end

      execute_instructions(instructions, new_state)
    end
  end

  def find_first_frequency(filename) do
    state = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
    |> execute_instructions(%State{})
    state.last_recovered
  end

end
