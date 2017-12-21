defmodule AC.Dec19Test do
  use ExUnit.Case
  alias AC.Dec19.Coord, as: Coord

  # problem 1
  test "example 1" do
    assert AC.Dec19.find_path("data/dec19_test_input.txt") == "ABCDEF"
  end

  # support
  test "grid file parsing" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input_grid.txt")

    assert Map.get(grid, %Coord{x: 1, y: 0}) == "a"
    assert Map.get(grid, %Coord{x: 2, y: 0}) == "b"
    assert Map.get(grid, %Coord{x: 0, y: 1}) == "c"
    assert Map.get(grid, %Coord{x: 1, y: 1}) == "d"
  end

  test "it finds the starting point" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input.txt")
    assert AC.Dec19.find_start(grid) == %Coord{x: 5, y: 0}
  end

  test "it returns the list of seen characters at the end" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input.txt")
    assert AC.Dec19.walk_path(grid, %Coord{x: 0, y: 3}, :left, ["Z"])[:seen] == ["Z"]
  end

  test "it moves across the finish line" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input.txt")
    assert AC.Dec19.walk_path(grid, %Coord{x: 3, y: 3}, :left, [])[:seen] == ["F"]
  end

  test "it turns a corner" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input_turn.txt")
    assert AC.Dec19.walk_path(grid, %Coord{x: 4, y: 1}, :right)[:seen] == ["Z"]
  end

  test "it turns right" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input_turn.txt")
    assert AC.Dec19.new_direction(grid, %Coord{x: 1, y: 1}, :down) == :right
  end

  test "it turns left" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input_turn.txt")
    assert AC.Dec19.new_direction(grid, %Coord{x: 5, y: 1}, :up) == :left
  end

  test "it turns up" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input_turn.txt")
    assert AC.Dec19.new_direction(grid, %Coord{x: 1, y: 1}, :left) == :up
  end

  test "it turns down" do
    grid = AC.Dec19.parse_grid("data/dec19_test_input_turn.txt")
    assert AC.Dec19.new_direction(grid, %Coord{x: 5, y: 1}, :right) == :down
  end

  # Part 2
  test "example 1 (2)" do
    assert AC.Dec19.count_steps("data/dec19_test_input.txt") == 38
  end
end
