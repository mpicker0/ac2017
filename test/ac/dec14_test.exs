defmodule AC.Dec14Test do
  use ExUnit.Case

  # problem 1
  test "example 1" do
    assert AC.Dec14.count_used_squares("flqrgnkx") == 8108
  end

  # problem 2
  test "example 1 (2)" do
    assert AC.Dec14.count_regions("flqrgnkx") == 1242
  end
end
