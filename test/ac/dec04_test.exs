defmodule AC.Dec04Test do
  use ExUnit.Case

  # problem 1

  test "test case 1 - valid" do
    assert AC.Dec04.valid_passphrase("aa bb cc dd ee") == true
  end

  test "test case 2 - invalid, aa is repeated" do
    assert AC.Dec04.valid_passphrase("aa bb cc dd aa") == false
  end

  test "test case 3 - valid, aa and aaa are different" do
    assert AC.Dec04.valid_passphrase("aa bb cc dd aaa") == true
  end
end
