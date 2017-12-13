defmodule AC.Dec13 do

  defmodule Layer do
    defstruct depth: nil, range: nil
  end

  def parse_line(line) do
    [d,r|_] = String.split(line, ": ")
    %Layer{depth: String.to_integer(d), range: String.to_integer(r)}
  end

  # Part 1
  def find_severity(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.to_list
    |> IO.inspect
    -1
  end

end
