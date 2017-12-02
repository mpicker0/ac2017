defmodule AC.Dec02 do
  import Enum

  def row_checksum(row) do
    {min, max} = min_max(row)
    max - min
  end

  def checksum(l) do
    l
      |> map(fn(row) -> row_checksum(row) end)
      |> sum
  end

  def each_pair(l) do
    for x <- Enum.with_index(l),
        y <- Enum.with_index(l),
        elem(x, 1) < elem(y, 1),
    do: {elem(x, 0), elem(y, 0)}
  end

  def divisible(t) do
    rem(elem(t, 0), elem(t, 1)) == 0 or
    rem(elem(t, 1), elem(t, 0)) == 0
  end

  def row_checksum_2(row) do
    pair = row |> each_pair |> find(fn(p) -> divisible(p) end)
    {small, large} = pair |> Tuple.to_list |> min_max
    div(large, small)
  end

  def checksum_2(l) do
    l
      |> map(fn(row) -> row_checksum_2(row) end)
      |> sum
  end

  # Support functions

  def parse_row(row) do
    import String
    split(row) |> map(fn(i) -> to_integer(i) end)
  end

  # This assumes the "spreadsheet" comes in as a single string with linebreaks
  # in the right places.  It splits it on whitespace, and produces a list of
  # lists, one for each line.
  def parse_spreadsheet(spreadsheet) do
    String.split(spreadsheet, "\n")
    |> map(fn(r) -> parse_row(r) end)
  end

  # User-facing functions

  def solve_checksum(spreadsheet) do
    parse_spreadsheet(spreadsheet) |> checksum
  end

  def solve_checksum_2(spreadsheet) do
    parse_spreadsheet(spreadsheet) |> checksum_2
  end
end
