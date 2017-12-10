defmodule AC.Dec07Test do
  use ExUnit.Case
  alias AC.Dec07.TreeNode, as: TreeNode

  # problem 1

  test "test case 1" do
    assert AC.Dec07.find_root("data/dec07_test_input.txt") == "tknk"
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

  # problem 2

  test "test case 1 (2)" do
    assert AC.Dec07.find_balance_weight("data/dec07_test_input.txt") == 60
  end

  test "total weight calculates the weight of a node and its children" do
    root   = %TreeNode{name: "root",   weight: 10,
                       children: ["left", "center", "right"]}
    left   = %TreeNode{name: "left",   weight: 1}
    center = %TreeNode{name: "center", weight: 2}
    right  = %TreeNode{name: "right",  weight: 3}
    tree = %{"root" => root,
             "left" => left, "center" => center, "right" => right}

    assert AC.Dec07.total_weight(tree, root) == 16
    assert AC.Dec07.total_weight(tree, center) == 2
  end

  test "total weight works recursively" do
    root   = %TreeNode{name: "root",   weight: 10, children: ["center"]}
    center = %TreeNode{name: "center", weight: 1, children: ["center_child"]}
    center_child = %TreeNode{name: "center_child", weight: 2,
      children: ["center_grandchild"]}
    center_grandchild = %TreeNode{name: "center_grandchild", weight: 3}
    tree = %{"root" => root,
             "center" => center,
             "center_child" => center_child,
             "center_grandchild" => center_grandchild
           }

    assert AC.Dec07.total_weight(tree, root) == 16
  end

end
