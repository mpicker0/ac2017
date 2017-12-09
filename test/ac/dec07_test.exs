defmodule AC.Dec07Test do
  use ExUnit.Case
  alias AC.Dec07.TreeNode, as: TreeNode

  # problem 1

  test "test case 1" do
    assert AC.Dec07.find_root("/usr/src/myapp/ac/data/dec07_test_input.txt") == "tknk"
  end

  # support

  test "it parses a line with children" do
    line = "fwft (72) -> ktlj, cntj, xhth"
    expected_node = %TreeNode{name: "fwft", weight: 72, children: ["ktlj", "cntj", "xhth"]}

    assert AC.Dec07.parse_line(line) == expected_node
  end

  test "it parses a line without children" do
    line = "ktlj (57)"
    expected_node = %TreeNode{name: "ktlj", weight: 57, children: []}

    assert AC.Dec07.parse_line(line) == expected_node
  end
end
