defmodule AC.Dec06Test do
  use ExUnit.Case

  # problem 1

  test "test case 1" do
    assert AC.Dec06.cycles_to_loop("0 2 7 0") == 5
  end

  # support

  test "it redistributes the memory (online examples)" do
    start = [0, 2, 7, 0]
    step1 = [2, 4, 1, 2]
    step2 = [3, 1 ,2 ,3]
    step3 = [0, 2, 3, 4]
    step4 = [1, 3, 4, 1]
    step5 = [2, 4, 1, 2]

    assert AC.Dec06.redistribute(start) == step1
    assert AC.Dec06.redistribute(step1) == step2
    assert AC.Dec06.redistribute(step2) == step3
    assert AC.Dec06.redistribute(step3) == step4
    assert AC.Dec06.redistribute(step4) == step5
  end

  test "it redistributes the memory exactly evenly" do
    start = [0, 0, 4, 0]
    assert AC.Dec06.redistribute(start) == [1, 1, 1, 1]
  end

  test "it redistributes the memory with one left over" do
    start = [0, 0, 5, 0]
    assert AC.Dec06.redistribute(start) == [1, 1, 1, 2]
  end

  test "it redistributes the memory with one left short" do
    start = [0, 0, 3, 0]
    assert AC.Dec06.redistribute(start) == [1, 1, 0, 1]
  end

  # imagine the array looks like [0, 1, 2, 3]
  test "will_reach_target simple" do
    assert AC.Dec06.will_reach_target?(0, 1, 2, 4) == :false
    assert AC.Dec06.will_reach_target?(0, 2, 2, 4) == :true
    assert AC.Dec06.will_reach_target?(0, 3, 2, 4) == :true
  end

  test "will_reach_target crossing over the end" do
    assert AC.Dec06.will_reach_target?(2, 2, 0, 4) == :true
    assert AC.Dec06.will_reach_target?(2, 1, 0, 4) == :false
  end

  # problem 2
  test "test case 1 (2)" do
    assert AC.Dec06.cycles_in_loop("0 2 7 0") == 4
  end
end
