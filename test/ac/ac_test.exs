defmodule ACTest do
  use ExUnit.Case

  test "parses a string into a list of integers" do
    assert AC.string_to_ints("1 2  3 4     5 ") == [1, 2, 3, 4, 5]
  end

  test "empty string becomes empty list" do
    assert AC.string_to_ints("") == []
  end

  test "whitespace-only string becomes empty list" do
    assert AC.string_to_ints("     ") == []
  end
end
