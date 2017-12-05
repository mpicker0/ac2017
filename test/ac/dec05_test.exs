defmodule AC.Dec05Test do
  use ExUnit.Case

  # problem 1

  test "test case 1" do
    assert AC.Dec05.maze_steps([0, 3, 0, 1, -3]) == 5
  end

  test "it ends when it goes negative" do
    assert AC.Dec05.maze_steps([0, 3, 0, 1, -6]) == 4
  end

  # problem 2

  test "test case 1 (2)" do
    #assert AC.Dec05.maze_steps_2([0, 3, 0, 1, -3]) == 10
  end

end
