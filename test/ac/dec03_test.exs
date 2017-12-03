defmodule AC.Dec03Test do
  use ExUnit.Case

  # problem 1

  test "test case 1" do
    assert AC.Dec03.distance(1) == 0
  end

  test "test case 2" do
    assert AC.Dec03.distance(12) == 3
  end

  test "test case 3" do
    assert AC.Dec03.distance(23) == 2
  end

  test "test case 4" do
    assert AC.Dec03.distance(1024) == 31
  end

  # problem 2

end
