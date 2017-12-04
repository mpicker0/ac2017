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

  # test "first greater than 3 is 4" do
  #   assert AC.Dec03.first_greater(3) == 4
  # end
  #
  # test "first greater than 330 is 351" do
  #   assert AC.Dec03.first_greater(330) == 351
  # end

  # support

  test "adjacent_values sums correctly with a full map" do
    matrix = %{ {-1,  1} => 1, {0,  1} => 1, {1,  1} => 1,
                {-1,  0} => 1, {0,  0} => 0, {1,  0} => 1,
                {-1, -1} => 1, {0, -1} => 1, {1, -1} => 1
              }
    assert AC.Dec03.adjacent_values(matrix, {0, 0}) == 8
  end

  test "adjacent_values sums correctly with a different starting point" do
    matrix = %{ {-1,  1} => 1, {0,  1} => 1, {1,  1} => 1,
                {-1,  0} => 1, {0,  0} => 0, {1,  0} => 0,
                {-1, -1} => 1, {0, -1} => 1, {1, -1} => 1
              }
    assert AC.Dec03.adjacent_values(matrix, {1, 0}) == 4
  end

  test "adjacent_values sums correctly with a partial map" do
    matrix = %{
                               {0,  0} => 0, {1,  0} => 4,
                                             {1, -1} => 1
              }
    assert AC.Dec03.adjacent_values(matrix, {0, 0}) == 5
  end

  test "value at position 1" do
    assert AC.Dec03.sum_at(1) == 1
  end

  test "value at position 2" do
    assert AC.Dec03.sum_at(2) == 1
  end

  test "value at position 4" do
    assert AC.Dec03.sum_at(4) == 4
  end

  test "value at position 5" do
    assert AC.Dec03.sum_at(5) == 5    
  end

  test "value at position 6" do
    assert AC.Dec03.sum_at(6) == 10
  end
  #
  # test "value at position 23" do
  #   assert AC.Dec03.sum_at(23) == 806
  # end
end
