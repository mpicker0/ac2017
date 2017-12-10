defmodule AC.Dec08 do
  defmodule Instruction do
    defstruct register: nil, command: nil, operand: nil,
              cond_register: nil, cond: nil, cond_operand: nil
  end

  def parse_line(line) do
    %{"register" => register, "command" => command, "operand" => operand,
      "cond_register" => cond_register, "cond" => cond, "cond_operand" => cond_operand} =
    Regex.named_captures(~r/(?<register>\w+) (?<command>\w+) (?<operand>-?\d+) if (?<cond_register>\w+) (?<cond>\S+) (?<cond_operand>-?\d+)/, line)
    %Instruction{
      register: register,
      command: String.to_atom(command),
      operand: String.to_integer(operand),
      cond_register: cond_register,
      cond: cond,
      cond_operand: String.to_integer(cond_operand)
    }
  end

  def condition_true?(registers, instruction) do
    cond_register = Map.get(registers, instruction.cond_register, 0)
    case instruction.cond do
      ">" -> cond_register > instruction.cond_operand
      "<" -> cond_register < instruction.cond_operand
      "==" -> cond_register == instruction.cond_operand
      ">=" -> cond_register >= instruction.cond_operand
      "<=" -> cond_register <= instruction.cond_operand
      "!=" -> cond_register != instruction.cond_operand
    end
  end

  def new_value_for_register(registers, instruction) do
    register = Map.get(registers, instruction.register, 0)
    case instruction.command do
      :inc -> register + instruction.operand
      :dec -> register - instruction.operand
    end
  end

  # Execute the instruction against the current set of registers and return the
  # updated registers
  def execute_instruction(registers, instruction) do
    if condition_true?(registers, instruction) do
      new_value = new_value_for_register(registers, instruction)
      new_max = max(new_value, Map.get(registers, :max, 0))
      registers
        |> Map.put(instruction.register, new_value)
        |> Map.put(:max, new_max)
    else
      registers
    end
  end

  def find_largest_value(filename) do
    registers = %{}
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce(registers, fn(inst, registers) ->
      execute_instruction(registers, inst) end)
    |> Map.delete(:max)  # :max comes from part 2; not needed here
    |> Map.values
    |> Enum.max
  end

  # Part 2

  def find_largest_value_ever(filename) do
    registers = %{}
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce(registers, fn(inst, registers) ->
      execute_instruction(registers, inst) end)
    |> Map.get(:max)
  end
end
