defmodule AC.Dec08Test do
  use ExUnit.Case
  alias AC.Dec08.Instruction, as: Instruction

  # problem 1
  test "test case 1" do
    assert AC.Dec08.find_largest_value("data/dec08_test_input.txt") == 1
  end

  # support
  test "it parses a line" do
    line = "a inc 5 if a > 1"
    expected_instruction =
      %Instruction{register: "a", command: :inc, operand: 5,
                   cond_register: "a", cond: ">", cond_operand: 1}

    assert AC.Dec08.parse_line(line) == expected_instruction
  end

  test "condition_true? for equals evaluates to true" do
    registers = %{"a" => 3}
    instruction = %Instruction{cond_register: "a", cond: "==", cond_operand: 3}
    assert AC.Dec08.condition_true?(registers, instruction) == :true
  end

  test "condition_true? for equals evaluates to false" do
    registers = %{"a" => 2}
    instruction = %Instruction{cond_register: "a", cond: "==", cond_operand: 3}
    assert AC.Dec08.condition_true?(registers, instruction) == :false
  end

  test "condition_true? if the register doesn't exist yet it's zero" do
    instruction = %Instruction{cond_register: "a", cond: "==", cond_operand: 0}
    assert AC.Dec08.condition_true?(%{}, instruction) == :true
  end

  test "new_value_for_register determines an increment value" do
    registers = %{"a" => 2}
    instruction = %Instruction{register: "a", command: :inc, operand: 1}
    assert AC.Dec08.new_value_for_register(registers, instruction) == 3
  end

  test "new_value_for_register determines an decrement value" do
    registers = %{"a" => 2}
    instruction = %Instruction{register: "a", command: :dec, operand: 1}
    assert AC.Dec08.new_value_for_register(registers, instruction) == 1
  end

  test "new_value_for_register uses zero for unseen registers" do
    instruction = %Instruction{register: "a", command: :dec, operand: -1}
    assert AC.Dec08.new_value_for_register(%{}, instruction) == 1
  end

  # problem 2

  test "test case 1 (2)" do
    assert AC.Dec08.find_largest_value_ever("data/dec08_test_input.txt") == 10
  end

end
