defmodule AC.Dec10Test do
  use ExUnit.Case

  # problem 1
  test "example 1" do
    assert AC.Dec10.find_product("3,4,1,5", 0..4) == 12
  end

  # support
  test "reverses part of a list" do
    input = [0, 1, 2, 3, 4]
    expected_output = [0, 3, 2, 1, 4]

    assert AC.Dec10.reverse_circular(input, 1, 3) == expected_output
  end

  test "reverses part of a list if it goes past the end" do
    input = [0, 1, 2, 3, 4]
    expected_output = [0, 4, 2, 3, 1]

    assert AC.Dec10.reverse_circular(input, 4, 3) == expected_output
  end

  test "reverses part of a list - from example 1" do
    input = [0, 1, 2, 3, 4]
    expected_output = [2, 1, 0, 3, 4]

    assert AC.Dec10.reverse_circular(input, 0, 3) == expected_output
  end

  test "reverses part of a list if it goes past the end - from example 2" do
    input = [2, 1, 0, 3, 4]
    expected_output = [4, 3, 0, 1, 2]

    assert AC.Dec10.reverse_circular(input, 3, 4) == expected_output
  end

  test "reverses a single element (no effect) - from example 3" do
    input = [4, 3, 0, 1, 2]

    assert AC.Dec10.reverse_circular(input, 1, 1) == input
  end

  test "reverses everything via a wrap - from example 5" do
    input = [4, 3, 0, 1, 2]
    expected_output = [3, 4, 2, 1, 0]

    assert AC.Dec10.reverse_circular(input, 1, 5) == expected_output
  end
end
