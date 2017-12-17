defmodule AC.Dec16Test do
  use ExUnit.Case

  # problem 1
  test "example 1" do
    start = String.graphemes("abcde")
    assert AC.Dec16.final_state("data/dec16_test_input.txt", start) == "baedc"
  end

  # support
  test "spin moves programs around" do
    start = String.graphemes("abcde")
    expected_end = String.graphemes("cdeab")

    assert AC.Dec16.spin(start, 3) == expected_end
  end

  test "exchange swaps two programs by position" do
    start = String.graphemes("eabcd")
    expected_end = String.graphemes("eabdc")

    assert AC.Dec16.exchange(start, 3, 4) == expected_end
  end

  test "partner swaps two programs by name" do
    start = String.graphemes("eabdc")
    expected_end = String.graphemes("baedc")

    assert AC.Dec16.partner(start, "e", "b") == expected_end
  end

  # problem 2
  # test "example 1 (2)" do
  #   start = String.graphemes("abcde")
  #   assert AC.Dec16.final_state_2("data/dec16_test_input.txt", start, 2) == "ceadb"
  # end

  # trying things out
  test "basic detect loop" do
    loop_list = [1, 2, 3, 4, 5, 2, 3, 4, 5]
    noloop_list = [1, 2, 3, 4, 5, 6, 7, 8]

    assert AC.Dec16.has_loop(loop_list) == :true
    assert AC.Dec16.has_loop(noloop_list) == :false
  end

  test "find loop start" do
    list = [1, 2, 3, 4, 5, 2, 3, 4, 5]

    assert AC.Dec16.loop_start(list) == 5
  end

  test "find loop length" do
    list = [1, 2, 3, 4, 5, 2, 3, 4, 5]

    assert AC.Dec16.loop_length(list) == 4
  end

end
