defmodule AC.Dec21Test do
  use ExUnit.Case

  # problem 1
  # test "example 1" do
  #   assert AC.Dec21.count_on_pixels("data/dec21_test_input.txt", 2) == 12
  # end

  # support
  test "rotate clockwise" do
    input = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    expected_output =
            [[7, 4, 1],
             [8, 5, 2],
             [9, 6, 3]]

    assert AC.Dec21.rotate_clockwise(input) == expected_output
  end

  test "flip" do
    input = [[1, 2, 3],
             [4, 5, 6],
             [7, 8, 9]]
    expected_output =
            [[3, 2, 1],
             [6, 5, 4],
             [9, 8, 7]]

    assert AC.Dec21.flip(input) == expected_output
  end

  test "get all rotations" do
    import MapSet
    input = [[1, 2],
             [3, 4]]
    rot1  = [[3, 1],
             [4, 2]]
    rot2  = [[4, 3],
             [2, 1]]
    rot3  = [[2, 4],
             [1, 3]]
    expected_output =
      %MapSet{} |> put(input) |> put(rot1) |> put(rot2) |> put(rot3)

    assert AC.Dec21.get_all_rotations(input, %MapSet{}, 4) == expected_output
  end

  test "get all versions" do
    import MapSet
    input = [[1, 2],
             [3, 4]]
    rot1  = [[3, 1],
             [4, 2]]
    rot2  = [[4, 3],
             [2, 1]]
    rot3  = [[2, 4],
             [1, 3]]
    flip1 = [[2, 1],
             [4, 3]]
    flip2 = [[4, 2],
             [3, 1]]
    flip3 = [[3, 4],
             [1, 2]]
    flip4 = [[1, 3],
             [2, 4]]
    expected_output =
      %MapSet{}
      |> put(input) |> put(rot1) |> put(rot2) |> put(rot3)
      |> put(flip1) |> put(flip2) |> put(flip3) |> put(flip4)

    assert AC.Dec21.get_all_versions(input) == expected_output
  end

  test "parse rule" do
    rule_line = "../.# => ##./#../..."
    expected_in = [String.codepoints(".."), String.codepoints(".#")]
    expected_out = [String.codepoints("##."), String.codepoints("#.."),
                    String.codepoints("...")]

    assert AC.Dec21.parse_rule(rule_line) == [in: expected_in, out: expected_out]
  end

  test "rule map builds a map with all possible rules" do
    rule_line = ".#./..#/### => #..#/..../..../#..#"
    expected_in = [String.codepoints(".#."), String.codepoints("..#"), String.codepoints("###")]
    expected_out = [] # doesn't matter for this test
    rule = [in: expected_in, out: expected_out]
    test1 = [String.codepoints(".#."), String.codepoints("..#"), String.codepoints("###")]
    test2 = [String.codepoints(".#."), String.codepoints("#.."), String.codepoints("###")]
    test3 = [String.codepoints("#.."), String.codepoints("#.#"), String.codepoints("##.")]
    test4 = [String.codepoints("###"), String.codepoints("..#"), String.codepoints(".#.")]

    all_rules = AC.Dec21.rule_map([rule])
    IO.inspect(all_rules)
    IO.inspect(test1)

    assert Map.has_key?(all_rules, test1)
    assert Map.has_key?(all_rules, test2)
    assert Map.has_key?(all_rules, test3)
    assert Map.has_key?(all_rules, test4)
  end

end
