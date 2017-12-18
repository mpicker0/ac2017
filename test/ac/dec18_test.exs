defmodule AC.Dec18Test do
  use ExUnit.Case
  alias AC.Dec18.State, as: State

  # problem 1
  test "example 1" do
    assert AC.Dec18.find_first_frequency("data/dec18_test_input.txt") == 4
  end

  # support
  test "get an operand directly from the instruction" do
    state = %State{registers: %{"X" => 1}}

    assert AC.Dec18.get_numeric_operand("X", state) == 1
  end

  test "get an operand from the register map" do
    assert AC.Dec18.get_numeric_operand("1", %State{}) == 1
  end

  test "snd changes the last_played in the current state" do
    inst = ["snd X"]
    state = %State{registers: %{"X" => 1}}

    assert AC.Dec18.execute_instructions(inst, state).last_played == 1
  end

  test "set updates a register to hold a given value" do
    inst = ["set X 1"]
    state = %State{registers: %{"X" => 0}}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert Map.get(new_state.registers, "X") == 1
  end

  test "add increases the value of a register" do
    inst = ["add X 2"]
    state = %State{registers: %{"X" => 1}}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert Map.get(new_state.registers, "X") == 3
  end

  test "mul increases one register by the value of another" do
    inst = ["mul X 3"]
    state = %State{registers: %{"X" => 2}}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert Map.get(new_state.registers, "X") == 6
  end

  test "mod sets a register X to the modulus X mod Y" do
    inst = ["mod X 2"]
    state = %State{registers: %{"X" => 7}}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert Map.get(new_state.registers, "X") == 1
  end

  test "rcv gets the last played sound if the register is nonzero" do
    inst = ["rcv X"]
    state = %State{registers: %{"X" => 1}, last_played: 1}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert new_state.last_recovered == 1
  end

  test "rcv does nothing if the register is zero" do
    inst = ["rcv X"]
    state = %State{registers: %{"X" => 0}, last_played: 1}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert new_state.last_recovered == nil
  end

  test "jgz moves the instruction pointer by Y if the first operand > zero" do
    inst = ["jgz X 2"]
    state = %State{registers: %{"X" => 1}}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert new_state.ip == 2
  end

  test "jmp moves the instruction pointer by 1 if the first operand is zero" do
    inst = ["jgz X 2"]
    state = %State{registers: %{"X" => 0}}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert new_state.ip == 1
  end
end
