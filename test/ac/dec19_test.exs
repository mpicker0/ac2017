defmodule AC.Dec19Test do
  use ExUnit.Case

  # problem 1
  test "example 1" do
    assert AC.Dec19.find_path("data/dec19_test_input.txt") == "ABCDEF"
  end

end
