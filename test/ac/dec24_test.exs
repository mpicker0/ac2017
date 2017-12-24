defmodule AC.Dec24Test do
  use ExUnit.Case
  alias AC.Dec24.Component, as: Component

  # problem 1
  test "example 1" do
    assert AC.Dec24.find_strongest_bridge("data/dec24_test_input.txt") == 31
  end

  test "build_bridge returns a single bridge" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [1, 2]}

    assert AC.Dec24.build_bridge([c1], [c2]) == [[c1, c2]]
  end

  test "build_bridge returns a multiple bridges" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [1, 2]}
    c3 = %Component{ports: [1, 3]}

    bridges = AC.Dec24.build_bridge([c1], [c2, c3])

    assert [c1, c2] in bridges
    assert [c1, c3] in bridges
  end

  test "build_bridge goes multiple levels deep" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [1, 2]}
    c3 = %Component{ports: [2, 3]}

    bridges = AC.Dec24.build_bridge([c1], [c2, c3])

    assert bridges == [[c1, c2, c3]]
  end

  test "build_bridge goes multiple levels deep - even further" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [1, 2]}
    c3 = %Component{ports: [2, 3]}
    c4 = %Component{ports: [3, 4]}

    bridges = AC.Dec24.build_bridge([c1], [c2, c3, c4])

    assert bridges == [[c1, c2, c3, c4]]
  end

  test "build_bridge ignores extra parts" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [1, 2]}
    c3 = %Component{ports: [9, 9]}
    assert AC.Dec24.build_bridge([c1], [c2, c3]) == [[c1, c2]]
  end

  test "build_bridge_start builds a bridge for each starting component" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [0, 2]}
    c3 = %Component{ports: [1, 2]}
    components = [c1, c2, c3]

    bridges = AC.Dec24.build_bridge_start(components)

    # Question: can zero components be used later?  Nothing says otherwise...
    assert [c1, c3, c2] in bridges
    assert [c2, c3, c1] in bridges
  end

  test "example from problem description" do
    # expected bridges; I'm only checking for the longest ones
    c_0_2 = %Component{ports: [0, 2]}
    c_2_2 = %Component{ports: [2, 2]}
    c_2_3 = %Component{ports: [2, 3]}
    c_3_4 = %Component{ports: [3, 4]}
    c_3_5 = %Component{ports: [3, 5]}
    c_0_1 = %Component{ports: [0, 1]}
    c_10_1 = %Component{ports: [10, 1]}
    c_9_10 = %Component{ports: [9, 10]}
    b1 = [c_0_1, c_10_1, c_9_10]
    b2 = [c_0_2, c_2_3, c_3_4]
    b3 = [c_0_2, c_2_3, c_3_5]
    b4 = [c_0_2, c_2_2, c_2_3, c_3_4]
    b5 = [c_0_2, c_2_2, c_2_3, c_3_5]
    components = [c_0_2, c_2_2, c_2_3, c_3_4, c_3_5, c_0_1, c_10_1, c_9_10]

    bridges = AC.Dec24.build_bridge_start(components)

    assert b1 in bridges
    assert b2 in bridges
    assert b3 in bridges
    assert b4 in bridges
    assert b5 in bridges
  end

  test "free_end finds the free end of a single-component bridge" do
    assert AC.Dec24.free_end([%Component{ports: [0, 1]}]) == 1
  end

  test "free_end finds the free end of the given bridge" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [2, 1]}
    c3 = %Component{ports: [3, 2]}

    assert AC.Dec24.free_end([c1, c2, c3]) == 3
  end

  test "free_end finds a free end when the ports are the same" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [1, 2]}
    c3 = %Component{ports: [2, 2]}

    assert AC.Dec24.free_end([c1, c2, c3]) == 2
  end

  test "bridge_strength calculates the strength" do
    c1 = %Component{ports: [0, 1]}
    c2 = %Component{ports: [1, 2]}
    c3 = %Component{ports: [2, 2]}

    assert AC.Dec24.bridge_strength([c1, c2, c3]) == 8
  end

  # Part 2
  test "example 1 (2)" do
    assert AC.Dec24.find_longest_bridge("data/dec24_test_input.txt") == 19
  end

end
