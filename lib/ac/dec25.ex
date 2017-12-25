defmodule AC.Dec25 do

  @iterations 12_459_852

  defmodule Instruction do
    defstruct write_value: nil, move_to: nil, next_machine_state: nil
  end

  defmodule State do
    defstruct machine_state: :a, location: 0, tape: %{}
  end

  def move_amount(dir) do
    case dir do
      :left  -> -1
      :right -> 1
    end
  end

  # Part 1
  def run_instructiondefs(_, state, 0) do
    state.tape
  end
  def run_instructiondefs(instructiondefs, state, iterations) do
    current_value = Map.get(state.tape, state.location, 0)
    instruction = Map.get(instructiondefs, state.machine_state)
    |> Map.get(current_value)
    new_state = %State{state |
      tape: Map.put(state.tape, state.location, instruction.write_value),
      location: state.location + move_amount(instruction.move_to),
      machine_state: instruction.next_machine_state
    }
    run_instructiondefs(instructiondefs, new_state, iterations - 1)
  end

  # Hardcoded :)
  def get_instructiondefs do
    %{
      :a => %{
        0 => %Instruction{write_value: 1, move_to: :right, next_machine_state: :b},
        1 => %Instruction{write_value: 1, move_to: :left,  next_machine_state: :e}
      },
      :b => %{
        0 => %Instruction{write_value: 1, move_to: :right, next_machine_state: :c},
        1 => %Instruction{write_value: 1, move_to: :right, next_machine_state: :f}
      },
      :c => %{
        0 => %Instruction{write_value: 1, move_to: :left,  next_machine_state: :d},
        1 => %Instruction{write_value: 0, move_to: :right, next_machine_state: :b}
      },
      :d => %{
        0 => %Instruction{write_value: 1, move_to: :right, next_machine_state: :e},
        1 => %Instruction{write_value: 0, move_to: :left,  next_machine_state: :c}
      },
      :e => %{
        0 => %Instruction{write_value: 1, move_to: :left,  next_machine_state: :a},
        1 => %Instruction{write_value: 0, move_to: :right, next_machine_state: :d}
      },
      :f => %{
        0 => %Instruction{write_value: 1, move_to: :right, next_machine_state: :a},
        1 => %Instruction{write_value: 1, move_to: :right, next_machine_state: :c}
      }
    }
  end

  def find_checksum(instructiondefs \\ get_instructiondefs(),
                    iterations \\ @iterations) do
    run_instructiondefs(instructiondefs, %State{}, iterations)
    |> Map.values
    |> Enum.count(fn(v) -> v == 1 end)
  end

end
