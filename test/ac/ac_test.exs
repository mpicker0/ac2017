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

  #

  test "convert a list to a frequency map" do
    assert AC.list_to_freq_map([1, 2, 1, 3, 2]) == %{1 => 2, 2 => 2, 3 => 1}
  end
end
