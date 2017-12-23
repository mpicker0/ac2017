defmodule AC.Dec22 do

  @iterations 10_000
  @iterations_2 10_000_000

  # Borrowed from Dec 19
  defmodule Coord do
    defstruct x: nil, y: nil
  end

  defmodule State do
    defstruct grid: nil, position: nil,
              direction: :up, infections: 0
  end

  def coord_at(map, x, y) do
    Map.get(map, %Coord{x: x, y: y}, ".")
  end

  # return a keyword list with :min_x :max_x :min_y :max_y
  def find_extremes(grid) do
    {{%Coord{x: min_x}, _}, {%Coord{x: max_x}, _}} =
      Enum.min_max_by(grid, fn({%Coord{x: x}, _}) -> x end)
    {{%Coord{y: min_y}, _}, {%Coord{y: max_y}, _}} =
      Enum.min_max_by(grid, fn({%Coord{y: y}, _}) -> y end)
    [min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y]
  end

  # for debugging
  def pretty_print(grid) do
    [min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y] =
      find_extremes(grid)
    Enum.map(min_y..max_y, fn(y) ->
      Enum.map(min_x..max_x, fn(x) ->coord_at(grid, x, y) end)
      |> Enum.join
      |> IO.puts
    end)
    grid
  end

  def print_state(state) do
    IO.puts("current position is (#{state.position.x}, #{state.position.y}); direction is #{Atom.to_string(state.direction)}")
  end

  # Borrowed from Dec 19
  def parse_grid(filename) do
    File.stream!(filename)
    |> Enum.with_index
    |> Stream.map(fn({s, y}) ->
         String.replace(s, "\n", "")
         |> String.codepoints
         |> Enum.with_index
         |> Enum.map(fn({b, x}) -> {%Coord{x: x, y: y}, b} end)
       end)
    |> Enum.to_list
    |> List.flatten
    |> Enum.reduce(%{}, fn({k, v}, acc) -> Map.put(acc, k, v) end)
  end

  def find_center(grid) do
    [min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y] =
      find_extremes(grid)
    %Coord{x: div(abs(max_x - min_x), 2), y: div(abs(max_y - min_y), 2)}
  end

  def turn_right(current_direction) do
    new_direction = %{up: :right, right: :down, down: :left, left: :up}
    Map.get(new_direction, current_direction)
  end

  def turn_left(current_direction) do
    new_direction = %{up: :left, left: :down, down: :right, right: :up}
    Map.get(new_direction, current_direction)
  end

  # Note: y is upside down; (0, 0) is the top-left corner
  def get_new_position(current_position, direction) do
    case direction do
      :up    -> %Coord{current_position | y: current_position.y - 1}
      :down  -> %Coord{current_position | y: current_position.y + 1}
      :left  -> %Coord{current_position | x: current_position.x - 1}
      :right -> %Coord{current_position | x: current_position.x + 1}
    end
  end

  # Part 1
  def activity_burst(state, 0), do: state
  def activity_burst(state, iterations) do
    current_node = Map.get(state.grid, state.position, ".")
    updates = case current_node do
      "#" -> [new_direction: turn_right(state.direction),
              new_grid: Map.put(state.grid, state.position, "."),
              new_infections: state.infections]
      _   -> [new_direction: turn_left(state.direction),
              new_grid: Map.put(state.grid, state.position, "#"),
              new_infections: state.infections + 1]
    end

    new_position = get_new_position(state.position, updates[:new_direction])
    new_state = %State{grid: updates[:new_grid],
                       position: new_position,
                       direction: updates[:new_direction],
                       infections: updates[:new_infections]}

    activity_burst(new_state, iterations - 1)
  end

  def count_infecting_bursts(filename, iterations \\ @iterations) do
    grid = parse_grid(filename)
    initial_position = find_center(grid)
    initial_state = %State{grid: grid, position: initial_position}
    final_state = activity_burst(initial_state, iterations)
    final_state.infections
  end

  # Part 2
  def reverse(current_direction) do
    new_direction = %{up: :down, left: :right, down: :up, right: :left}
    Map.get(new_direction, current_direction)
  end

  def activity_burst_2(state, 0), do: state
  def activity_burst_2(state, iterations) do
    current_node = Map.get(state.grid, state.position, ".")
    updates = case current_node do
      "." -> [new_direction: turn_left(state.direction),
              new_grid: Map.put(state.grid, state.position, "W"),
              new_infections: state.infections]
      "W" -> [new_direction: state.direction,
              new_grid: Map.put(state.grid, state.position, "#"),
              new_infections: state.infections + 1]
      "#" -> [new_direction: turn_right(state.direction),
              new_grid: Map.put(state.grid, state.position, "F"),
              new_infections: state.infections]
      "F" -> [new_direction: reverse(state.direction),
              new_grid: Map.put(state.grid, state.position, "."),
              new_infections: state.infections]
    end

    new_position = get_new_position(state.position, updates[:new_direction])
    new_state = %State{grid: updates[:new_grid],
                       position: new_position,
                       direction: updates[:new_direction],
                       infections: updates[:new_infections]}

    activity_burst_2(new_state, iterations - 1)
  end

  def count_infecting_bursts_2(filename, iterations \\ @iterations_2) do
    grid = parse_grid(filename)
    initial_position = find_center(grid)
    initial_state = %State{grid: grid, position: initial_position}
    final_state = activity_burst_2(initial_state, iterations)
    final_state.infections
  end
end
