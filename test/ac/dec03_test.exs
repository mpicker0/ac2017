defmodule AC.Dec03Test do
  use ExUnit.Case

  # problem 1

  test "test case 1" do
    assert AC.Dec03.distance_from_origin(1) == 0
  end

  test "test case 2" do
    assert AC.Dec03.distance_from_origin(12) == 3
  end

  test "test case 3" do
    assert AC.Dec03.distance_from_origin(23) == 2
  end

  test "test case 4" do
    assert AC.Dec03.distance_from_origin(1024) == 31
  end

  test "no up component" do
    assert AC.Dec03.distance_from_origin(2) == 1
  end

  test "no left component" do
    assert AC.Dec03.distance_from_origin(3) == 2
  end

  test "no down component" do
    assert AC.Dec03.distance_from_origin(5) == 2
  end

  # problem 2

  test "first greater than 3 is 4" do
    assert AC.Dec03.first_greater(3) == 4
  end

  # support

  test "value at position 1" do
    assert AC.Dec03.sum_at(1) == 1
  end

  test "value at position 2" do
    assert AC.Dec03.sum_at(2) == 1
  end

  test "value at position 6" do
    assert AC.Dec03.sum_at(6) == 10
  end

  test "value at position 23" do
    assert AC.Dec03.sum_at(23) == 806
  end
end
