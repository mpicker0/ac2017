defmodule AC.Dec14Test do
  use ExUnit.Case
  alias AC.Dec14.Coord, as: Coord

  # problem 1
  test "example 1" do
    assert AC.Dec14.count_used_squares("flqrgnkx") == 8108
  end

  # problem 2
  test "example 1 (2)" do
    assert AC.Dec14.count_regions("flqrgnkx") == 1242
  end

  # support for debugging
  def format_atom(atom) do
    case atom do
      :used -> "#"
      :free -> "."
      :visited -> "V"
      _ -> "?"
    end
  end
  def output_grid(grid) do
    max_x = 3
    max_y = 3
    Enum.each(0..max_y, fn(y) ->
      line = Enum.map(0..max_x, fn(x) ->
        format_atom(Map.get(grid, %Coord{x: x, y: y}))
      end)
      IO.puts(line)
    end)
  end

  test "continues to mark used neighbors of things it marks" do
    grid = %{
      %Coord{x: 0, y: 0} => :used, %Coord{x: 1, y: 0} => :free, %Coord{x: 2, y: 0} => :free, %Coord{x: 3, y: 0} => :free,
      %Coord{x: 0, y: 1} => :used, %Coord{x: 1, y: 1} => :free, %Coord{x: 2, y: 1} => :free, %Coord{x: 3, y: 1} => :free,
      %Coord{x: 0, y: 2} => :used, %Coord{x: 1, y: 2} => :free, %Coord{x: 2, y: 2} => :free, %Coord{x: 3, y: 2} => :free,
      %Coord{x: 0, y: 3} => :free, %Coord{x: 1, y: 3} => :free, %Coord{x: 2, y: 3} => :free, %Coord{x: 3, y: 3} => :free
    }

    marked = AC.Dec14.mark_neighbors(grid, %Coord{x: 0, y: 0})

    # TODO this is not a great assertion ...
    assert Enum.filter(marked, fn({_, v}) -> v == :visited end) |> length == 3
  end

  test "continues to mark used neighbors of things it marks - 2" do
    grid = %{
      %Coord{x: 0, y: 0} => :used, %Coord{x: 1, y: 0} => :used, %Coord{x: 2, y: 0} => :used, %Coord{x: 3, y: 0} => :free,
      %Coord{x: 0, y: 1} => :used, %Coord{x: 1, y: 1} => :free, %Coord{x: 2, y: 1} => :free, %Coord{x: 3, y: 1} => :free,
      %Coord{x: 0, y: 2} => :used, %Coord{x: 1, y: 2} => :free, %Coord{x: 2, y: 2} => :used, %Coord{x: 3, y: 2} => :free,
      %Coord{x: 0, y: 3} => :used, %Coord{x: 1, y: 3} => :free, %Coord{x: 2, y: 3} => :used, %Coord{x: 3, y: 3} => :free
    }

    marked = AC.Dec14.mark_neighbors(grid, %Coord{x: 0, y: 0})
    assert Enum.filter(marked, fn({_, v}) -> v == :visited end) |> length == 6
  end

  test "mark grid" do
    grid = %{
      %Coord{x: 0, y: 0} => :used, %Coord{x: 1, y: 0} => :used, %Coord{x: 2, y: 0} => :used, %Coord{x: 3, y: 0} => :free,
      %Coord{x: 0, y: 1} => :used, %Coord{x: 1, y: 1} => :free, %Coord{x: 2, y: 1} => :free, %Coord{x: 3, y: 1} => :free,
      %Coord{x: 0, y: 2} => :used, %Coord{x: 1, y: 2} => :free, %Coord{x: 2, y: 2} => :used, %Coord{x: 3, y: 2} => :free,
      %Coord{x: 0, y: 3} => :used, %Coord{x: 1, y: 3} => :free, %Coord{x: 2, y: 3} => :used, %Coord{x: 3, y: 3} => :free
    }

    # TODO no assertions
    AC.Dec14.mark_grid(grid)
  end

end
