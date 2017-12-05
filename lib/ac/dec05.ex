defmodule AC.Dec05 do
  import Enum

  def maze_steps_r(maze, offset, count) do
    if offset < 0 or offset > length(maze) - 1 do
      count
    else
      this_item = at(maze, offset)
      new_offset = offset + this_item
      maze_steps_r(List.replace_at(maze, offset, this_item + 1), new_offset, count + 1)
    end
  end

  def maze_steps(maze) do
    maze_steps_r(maze, 0, 0)
  end

  def maze_steps_from_file(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn (line) -> String.to_integer(line) end)
    |> Enum.to_list
    |> maze_steps
  end

  def maze_steps_2_r(maze, offset, count) do
    IO.puts("----")
    IO.puts("maze is: ")
    IO.inspect(maze)
    IO.puts(:io_lib.format "offset is: ~B, count is: ~B", [offset, count])
    -1
  end

  def maze_steps_2(maze) do
    maze_steps_2_r(maze, 0, 0)
  end

  def maze_steps_from_file_2(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn (line) -> String.to_integer(line) end)
    |> Enum.to_list
    |> maze_steps_2
  end

end
