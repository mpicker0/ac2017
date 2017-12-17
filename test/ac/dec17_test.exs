defmodule AC.Dec17Test do
  use ExUnit.Case

  @example_steps 3

  # problem 1
  test "example 1" do
    assert AC.Dec17.find_value_after_last(3) == 638
  end

  # support
  test "step forward from initial state" do
    assert AC.Dec17.step_forward([0], @example_steps, 0, 0, 1) == [0, 1]
  end

  test "step forward two steps from initial state" do
    assert AC.Dec17.step_forward([0], @example_steps, 0, 0, 2) == [0, 2, 1]
  end

  test "step forward nine steps from initial state" do
    state_9 = [0, 9, 5, 7, 2, 4, 3, 8, 6, 1]
    assert AC.Dec17.step_forward([0], @example_steps, 0, 0, 9) == state_9
  end

end
