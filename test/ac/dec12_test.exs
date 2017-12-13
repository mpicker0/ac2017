defmodule AC.Dec12Test do
  use ExUnit.Case

  # problem 1

  # support
  test "contains_any_of? returns true" do
    map = MapSet.new |> MapSet.put(1) |> MapSet.put(2)
    assert AC.Dec12.contains_any_of?(map, [0, 1]) == :true
  end

  test "contains_any_of? returns false" do
    map = MapSet.new |> MapSet.put(1) |> MapSet.put(2)
    assert AC.Dec12.contains_any_of?(map, [0]) == :false
  end
end
