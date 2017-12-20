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

  test "jgz moves the instruction pointer backwards" do
    inst = ["jgz X -2"]
    state = %State{registers: %{"X" => 1}}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert new_state.ip == -2
  end

  test "jgz moves the instruction pointer by 1 if the first operand is zero" do
    inst = ["jgz X 2"]
    state = %State{registers: %{"X" => 0}}

    new_state = AC.Dec18.execute_instructions(inst, state)

    assert new_state.ip == 1
  end

  test "jgz handles a literal as the first operand" do
    inst = ["jgz 1 2"]

    new_state = AC.Dec18.execute_instructions(inst, %State{})

    assert new_state.ip == 2
  end

  # Part 2
  alias AC.Dec18.State2, as: State2

  test "example 1 (2)" do
    assert AC.Dec18.find_prog_1_sends("data/dec18_test_input_2.txt") == 3
  end

  test "test send, receive, send, receive combination" do
    assert AC.Dec18.find_prog_1_sends("data/dec18_test_input_3.txt") == 4
  end

  test "test deadlock" do
    assert AC.Dec18.find_prog_1_sends("data/dec18_test_input_4.txt") == 0
  end

  test "snd puts messages into the outbound queue and increments the send count" do
    inst = ["snd X", "snd Y"]
    state = %State2{registers: %{"X" => 1, "Y" => 2}}

    new_state = AC.Dec18.execute_instructions_2(inst, state)
    assert new_state.out_queue == [1, 2]
    assert new_state.send_count == 2
  end

  test "rcv takes a message from the inbound queue" do
    inst = ["rcv X"]
    state = %State2{in_queue: [1, 2]}

    new_state = AC.Dec18.execute_instructions_2(inst, state)

    assert new_state.in_queue == [2]
    assert Map.get(new_state.registers, "X") == 1
  end

  test "rcv sets the status to waiting if nothing is in the queue" do
    inst = ["rcv X", "jgz X 2"]
    state = %State2{in_queue: []}

    new_state = AC.Dec18.execute_instructions_2(inst, state)

    assert new_state.execution_status == :waiting
  end

  test "rcv, snd, and rcv again" do
    inst = ["rcv X", "snd X", "rcv X"]
    state = %State2{in_queue: [1]}

    new_state = AC.Dec18.execute_instructions_2(inst, state)

    assert Map.get(new_state.registers, "X") == 1
    assert new_state.in_queue == []
    assert new_state.out_queue == [1]
    assert new_state.execution_status == :waiting
  end

end
