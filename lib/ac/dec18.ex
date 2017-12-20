defmodule AC.Dec18 do

  defmodule State do
    defstruct registers: %{}, ip: 0, last_played: nil, last_recovered: nil, terminate: :false
  end

  # Part 1
  def get_numeric_operand(operand, state) do
    case Integer.parse(operand) do
      {i, _} -> i
      :error -> Map.get(state.registers, operand, 0)
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
          test_value = get_numeric_operand(test, state)
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

  # Part 2

  defmodule State2 do
    defstruct registers: %{}, ip: 0, in_queue: [], out_queue: [], execution_status: :running, send_count: 0
  end

  def execute_instructions_2(instructions, state) do
    cond do
      state.ip < 0 or state.ip  >= length(instructions) ->
        %{state | execution_status: :finished}
      state.execution_status == :finished ||
        (state.execution_status == :waiting && state.in_queue == []) ->
        state
      true ->
        [instruction | operands] = Enum.at(instructions, state.ip)
          |> String.split
        # TODO refactor to remove common code
        new_state = case instruction do
          "snd" ->
            [val] = operands
            value = get_numeric_operand(val, state)
            %{state | out_queue: state.out_queue ++ [value], send_count: state.send_count + 1, ip: state.ip + 1}
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
            case state.in_queue do
              [] ->
                %{state | execution_status: :waiting}
              [h|t] ->
                %{state | registers: Map.put(state.registers, register, h), in_queue: t, execution_status: :running, ip: state.ip + 1}
            end
          "jgz" ->
            [test, amt] = operands
            amount = get_numeric_operand(amt, state)
            test_value = get_numeric_operand(test, state)
            if (test_value > 0), do: %{state | ip: state.ip + amount}, else: %{state | ip: state.ip + 1}
        end
        execute_instructions_2(instructions, new_state)
    end
  end

  # stopping condition:  both programs have ended
  # ended means:
  #   finished (out of instructions; ip is outside the instruction list)
  #   hung, which means:
  #     waiting, nothing in the queue, and the other program is either waiting or finished
  def run_instructions(instructions, state_0, state_1) do
    if (state_0.execution_status == :finished ||
        (state_0.execution_status == :waiting and state_0.in_queue == [])
       ) and (
       (state_1.execution_status == :finished) ||
        (state_1.execution_status == :waiting and state_1.in_queue == [])
       ) do
         state_1.send_count
    else
      new_state_0 = execute_instructions_2(instructions, state_0)
      new_state_1 = execute_instructions_2(instructions, state_1)

      # append the output queue of each to the input queue of the other and recurse
      run_instructions(
        instructions,
        %{new_state_0 | in_queue: new_state_0.in_queue ++ new_state_1.out_queue, out_queue: []},
        %{new_state_1 | in_queue: new_state_1.in_queue ++ new_state_0.out_queue, out_queue: []}
      )
    end
  end

  def find_prog_1_sends(filename) do
    instructions = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list

    # create two different initial states
    state_0 = %State2{registers: %{"p" => 0, "**Orig**" => "* 0 *"}}
    state_1 = %State2{registers: %{"p" => 1, "**Orig**" => "* 1 *"}}

    run_instructions(instructions, state_0, state_1)
  end

end
