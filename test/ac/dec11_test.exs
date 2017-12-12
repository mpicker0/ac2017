defmodule AC.Dec11Test do
  use ExUnit.Case

  # problem 1
  test "example 1 (basic)" do
    assert AC.Dec11.find_steps_s("ne,ne,ne") == 3
  end

  test "example 2 (end at starting point)" do
    assert AC.Dec11.find_steps_s("ne,ne,sw,sw") == 0
  end

  test "example 3" do
    assert AC.Dec11.find_steps_s("ne,ne,s,s") == 2
  end

  test "example 4" do
    assert AC.Dec11.find_steps_s("se,sw,se,sw,sw") == 3
  end

  # support
  test "list to frequency map" do
    assert AC.Dec11.list_to_freq_map([:a, :b, :a, :c]) == %{a: 2, b: 1, c: 1}
  end

  # TODO the order of the output shouldn't matter
  test "frequency map to list" do
    assert AC.Dec11.freq_map_to_list(%{a: 2, b: 1, c: 1}) == [:a, :a, :b, :c]
  end

  test "collapse pairs" do
    assert AC.Dec11.collapse_pairs([:n, :se, :s, :nw, :n]) == [:n]
  end

  test "collapse combinations" do
    assert AC.Dec11.collapse_combinations([:ne, :s, :se]) == [:se, :se]
  end
end
