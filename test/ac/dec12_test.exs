defmodule AC.Dec12Test do
  use ExUnit.Case

  # problem 1
  test "example 1" do
    assert AC.Dec12.how_many_programs_in_input("data/dec12_test_input.txt") == 6
  end

  # problem 2
  test "example 1 (2)" do
    assert AC.Dec12.how_many_groups_in_input("data/dec12_test_input.txt") == 2
  end
end
