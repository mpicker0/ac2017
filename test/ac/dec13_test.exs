defmodule AC.Dec13Test do
  use ExUnit.Case

  # problem 1
  test "example 1" do
    assert AC.Dec13.find_severity("data/dec13_test_input.txt") == 24
  end

end
