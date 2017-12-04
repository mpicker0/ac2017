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

  # problem 2

  test "test case 1 - valid (2)" do
    assert AC.Dec04.valid_passphrase_2("abcde fghij") == true
  end

  test "test case 2 - invalid, first and second words are anagrams (2)" do
    assert AC.Dec04.valid_passphrase_2("abcde xyz ecdab") == false
  end

  test "test case 3 - valid (2)" do
    assert AC.Dec04.valid_passphrase_2("a ab abc abd abf abj") == true
  end

  test "test case 4 - valid (2)" do
    assert AC.Dec04.valid_passphrase_2("iiii oiii ooii oooi oooo") == true
  end
end
