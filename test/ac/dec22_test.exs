defmodule AC.Dec22Test do
  use ExUnit.Case

  # problem 1
  test "example 1" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt", 7) == 5
  end

  test "example 2" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt", 70) == 41
  end

  test "final example" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt") == 5587
  end

end
