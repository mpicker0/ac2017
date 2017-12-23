defmodule AC.Dec22Test do
  use ExUnit.Case
  alias AC.Dec22.Coord, as: Coord
  alias AC.Dec22.State, as: State

  # problem 1
  test "example 1" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt", 7) == 5
  end

  test "example 2" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt", 70) == 41
  end

  test "final example" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt") == 5587
  end

  # These "n iterations" tests are really more about visually inspecting the
  # state of the grid.
  test "one iteration" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt", 1) == 1
  end

  test "two iterations" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt", 2) == 1
  end

  test "six iterations" do
    assert AC.Dec22.count_infecting_bursts("data/dec22_test_input.txt", 6) == 5
  end

  # internal
  test "two iterations internal" do
    grid = AC.Dec22.parse_grid("data/dec22_test_input.txt")
    initial_position = %Coord{x: 1, y: 1}
    initial_state = %State{grid: grid, position: initial_position}

    final_state = AC.Dec22.activity_burst(initial_state, 2)

    assert final_state.infections == 1
    assert final_state.position == %Coord{x: 0, y: 0}
    assert final_state.direction == :up
  end

  test "it infects an clean square, turns left, moves left, and counts it" do
    grid = AC.Dec22.parse_grid("data/dec22_test_input.txt")
    initial_position = %Coord{x: 1, y: 1}
    initial_state = %State{grid: grid, position: initial_position}

    final_state = AC.Dec22.activity_burst(initial_state, 1)

    assert final_state.infections == 1
    assert AC.Dec22.coord_at(final_state.grid, 1, 1) == "#"
    assert final_state.position == %Coord{x: 0, y: 1}
    assert final_state.direction == :left
  end

  test "it cleans an infected square, turns right, and moves right" do
    grid = AC.Dec22.parse_grid("data/dec22_test_input.txt")
    initial_position = %Coord{x: 0, y: 1}
    initial_state = %State{grid: grid, position: initial_position}

    final_state = AC.Dec22.activity_burst(initial_state, 1)

    assert final_state.infections == 0
    assert AC.Dec22.coord_at(final_state.grid, 0, 1) == "."
    assert final_state.position == %Coord{x: 1, y: 1}
    assert final_state.direction == :right
  end

  test "it successfully 'creates' a new square if it moves off the edge" do
    grid = AC.Dec22.parse_grid("data/dec22_test_input.txt")
    initial_position = %Coord{x: 0, y: 0}
    initial_state = %State{grid: grid, position: initial_position}

    final_state = AC.Dec22.activity_burst(initial_state, 2)

    assert AC.Dec22.coord_at(final_state.grid, 0, 0) == "#"
    assert AC.Dec22.coord_at(final_state.grid, -1, 0) == "#"
  end
end
