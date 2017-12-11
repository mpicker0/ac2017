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

  # Part 2
  test "example 1 (2) - empty string" do
    assert AC.Dec10.find_hash("") == "a2582a3a0e66e6e86e3812dcb672a272"
  end

  test "example 2 (2)" do
    assert AC.Dec10.find_hash("AoC 2017") == "33efeb34ea91902bb2f59c9920caa6cd"
  end

  test "example 3 (2)" do
    assert AC.Dec10.find_hash("1,2,3") == "3efbe78a8d82f29979031a4aa0b16a9d"
  end

  test "example 4 (2)" do
    assert AC.Dec10.find_hash("1,2,4") == "63960835bcdc130f0b66d7ff4f6a5a8e"
  end

  test "compute_dense_hash example" do
    input = [65, 27, 9, 1, 4, 3, 40, 50, 91, 7, 6, 0, 2, 5, 68, 22,
             65, 27, 9, 1, 4, 3, 40, 50, 91, 7, 6, 0, 2, 5, 68, 22]

    assert AC.Dec10.compute_dense_hash(input) == [64, 64]
  end

  test "hex_string example" do
    input = [64, 7, 255]

    assert AC.Dec10.hex_string(input) == "4007ff"
  end
end
