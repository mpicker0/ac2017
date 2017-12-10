defmodule AC.Dec09Test do
  use ExUnit.Case
  alias AC.Dec09.State, as: State

  # problem 1
  test "example 1" do
    assert AC.Dec09.total_score_in_sample("{}") == 1
  end

  test "example 2" do
    assert AC.Dec09.total_score_in_sample("{{{}}}") == 6
  end

  test "example 3" do
    assert AC.Dec09.total_score_in_sample("{{},{}}") == 5
  end

  test "example 4" do
    assert AC.Dec09.total_score_in_sample("{{{},{},{{}}}}") == 16
  end

  test "example 5" do
    assert AC.Dec09.total_score_in_sample("{<a>,<a>,<a>,<a>}") == 1
  end

  test "example 6" do
    assert AC.Dec09.total_score_in_sample("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
  end

  test "example 7" do
    assert AC.Dec09.total_score_in_sample("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
  end

  test "example 8" do
    assert AC.Dec09.total_score_in_sample("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
  end

  # support
  test "it finds six groups" do
    input = String.graphemes("{{{},{},{{}}}}")

    result = AC.Dec09.process_sample(input, %State{})
    assert length(result.group_scores) == 6
  end

  # problem 2
  test "example 1 (2)" do
    assert AC.Dec09.count_garbage("<>") == 0
  end

  test "example 2 (2)" do
    assert AC.Dec09.count_garbage("<random characters>") == 17
  end

  test "example 3 (2)" do
    assert AC.Dec09.count_garbage("<<<<>") == 3
  end

  test "example 4 (2)" do
    assert AC.Dec09.count_garbage("<{!>}>") == 2
  end

  test "example 5 (2)" do
    assert AC.Dec09.count_garbage("<!!>") == 0
  end

  test "example 6 (2)" do
    assert AC.Dec09.count_garbage("<!!!>>") == 0
  end

  test "example 7 (2)" do
    assert AC.Dec09.count_garbage("<{o\"i!a,<{i<a>") == 10
  end

end
