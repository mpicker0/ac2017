defmodule AC.Dec01Test do
  use ExUnit.Case

  # problem 1

  test "first test case from example" do
    assert AC.Dec01.solve_capcha("1122") == 3
  end

  test "second test case from example (matching digits)" do
    assert AC.Dec01.solve_capcha("1111") == 4
  end

  test "third test case from example (no matching digits)" do
    assert AC.Dec01.solve_capcha("1234") == 0
  end

  test "fourth test case from example (one matching digit)" do
    assert AC.Dec01.solve_capcha("91212129") == 9
  end

  # problem 2

  test "first test case from example - 2" do
    assert AC.Dec01.solve_capcha_2("1212") == 6
  end

  test "second test case from example (no matching digits - 2)" do
    assert AC.Dec01.solve_capcha_2("1221") == 0
  end

  test "third test case from example (one matching digit - 2)" do
    assert AC.Dec01.solve_capcha_2("123425") == 4
  end

  test "fourth test case from example (2)" do
    assert AC.Dec01.solve_capcha_2("123123") == 12
  end

  test "fifth test case from example (2)" do
    assert AC.Dec01.solve_capcha_2("12131415") == 4
  end
end
