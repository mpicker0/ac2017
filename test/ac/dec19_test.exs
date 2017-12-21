defmodule AC.Dec19Test do
  use ExUnit.Case
  alias AC.Dec19.Coord, as: Coord

  # problem 1
  test "example 1" do
    assert AC.Dec19.find_path("data/dec19_test_input.txt") == "ABCDEF"
  end

  # support
  test "grid file parsing" do
    grid_map = AC.Dec19.parse_grid("data/dec19_test_input_grid.txt")

    assert Map.get(grid_map, %Coord{x: 0, y: 0}) == "a"
    assert Map.get(grid_map, %Coord{x: 1, y: 0}) == "b"
    assert Map.get(grid_map, %Coord{x: 0, y: 1}) == "c"
    assert Map.get(grid_map, %Coord{x: 1, y: 1}) == "d"
  end

end
