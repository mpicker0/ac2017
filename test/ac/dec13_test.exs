defmodule AC.Dec13Test do
  use ExUnit.Case
  alias AC.Dec13.Layer, as: Layer

  # problem 1
  test "example 1" do
    assert AC.Dec13.find_severity("data/dec13_test_input.txt") == 24
  end

  # support
  test "move_scanners" do
    start_state = %{
      0 => %Layer{depth: 0, range: 3},
      1 => %Layer{depth: 1, range: 2},
      2 => %Layer{depth: 2, range: 1}
    }
    start_plus_1 = %{
      0 => %Layer{depth: 0, range: 3, scanner_location: 1},
      1 => %Layer{depth: 1, range: 2, scanner_location: 1},
      2 => %Layer{depth: 2, range: 1, scanner_location: 0}
    }
    # I'm not happy about having to specify the direction attributes on these,
    # as I don't care about the internal implementation; maybe there's a way to
    # ignore this attribute.
    start_plus_2 = %{
      0 => %Layer{depth: 0, range: 3, scanner_location: 2},
      1 => %Layer{depth: 1, range: 2, scanner_location: 0, direction: -1},
      2 => %Layer{depth: 2, range: 1, scanner_location: 0}
    }
    start_plus_3 = %{
      0 => %Layer{depth: 0, range: 3, scanner_location: 1, direction: -1},
      1 => %Layer{depth: 1, range: 2, scanner_location: 1},
      2 => %Layer{depth: 2, range: 1, scanner_location: 0}
    }

    assert AC.Dec13.move_scanners(start_state) == start_plus_1
    assert AC.Dec13.move_scanners(start_plus_1) == start_plus_2
    assert AC.Dec13.move_scanners(start_plus_2) == start_plus_3
  end

  # problem 2
  test "example 1 (2)" do
    #assert AC.Dec13.find_shortest_delay("data/dec13_test_input.txt") == 10
  end

end
