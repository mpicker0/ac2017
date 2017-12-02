defmodule AC.Dec02Test do
  use ExUnit.Case

  # problem 1

  test "test case from example" do
    spreadsheet = [
      [5, 1, 9, 5],
      [7, 5, 3],
      [2, 4, 6, 8]
    ]
    assert AC.Dec02.checksum(spreadsheet) == 18
  end

  # problem 2

  test "test case from example (2)" do
    spreadsheet = [
      [5, 9, 2, 8],
      [9, 4, 7, 3],
      [3, 8, 6, 5]
    ]
    assert AC.Dec02.checksum_2(spreadsheet) == 9
  end

  # utility

  test "spreadsheet parser" do
    spreadsheet =
      "5 1 9 5
       7 5 3
       2 4 6 8"
     parsed_spreadsheet = [
       [5, 1, 9, 5],
       [7, 5, 3],
       [2, 4, 6, 8]
     ]
    assert AC.Dec02.parse_spreadsheet(spreadsheet) == parsed_spreadsheet
  end

end
