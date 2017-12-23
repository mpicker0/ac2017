defmodule AC.Dec21Test do
  use ExUnit.Case

  # problem 1
  test "example 1" do
    assert AC.Dec21.count_on_pixels("data/dec21_test_input.txt", 2) == 12
  end

  # integration
  test "first iteration from example" do
    start = AC.Dec21.parse_grid(".#./..#/###")
    rule_1 = AC.Dec21.parse_rule("../.# => ##./#../...")
    rule_2 = AC.Dec21.parse_rule(".#./..#/### => #..#/..../..../#..#")
    all_rules = AC.Dec21.rule_map([rule_1, rule_2])
    expected_out = AC.Dec21.parse_grid("#..#/..../..../#..#")

    assert AC.Dec21.iterate_on_pixels(start, all_rules, 1) == expected_out
  end

  test "second iteration from example" do
    start = AC.Dec21.parse_grid("#..#/..../..../#..#")
    rule_1 = AC.Dec21.parse_rule("../.# => ##./#../...")
    rule_2 = AC.Dec21.parse_rule(".#./..#/### => #..#/..../..../#..#")
    all_rules = AC.Dec21.rule_map([rule_1, rule_2])
    expected_out = AC.Dec21.parse_grid("##.##./#..#../....../##.##./#..#../......")

    assert AC.Dec21.iterate_on_pixels(start, all_rules, 1) == expected_out
  end

  test "two iterations from example" do
    start = AC.Dec21.parse_grid(".#./..#/###")
    rule_1 = AC.Dec21.parse_rule("../.# => ##./#../...")
    rule_2 = AC.Dec21.parse_rule(".#./..#/### => #..#/..../..../#..#")
    all_rules = AC.Dec21.rule_map([rule_1, rule_2])
    expected_out = AC.Dec21.parse_grid("##.##./#..#../....../##.##./#..#../......")

    assert AC.Dec21.iterate_on_pixels(start, all_rules, 2) == expected_out
  end

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

  test "parse grid" do
    grid_line = "../.#"
    expected_grid = [[".", "."], [".", "#"]]

    assert AC.Dec21.parse_grid(grid_line) == expected_grid
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

  test "split a 4x4 grid into four 2x2 grids" do
    # input looks like: 1 2
    #                   3 4
    in_grid = AC.Dec21.parse_grid("0123/4567/89ab/cdef")
    out_grid_1 = AC.Dec21.parse_grid("01/45")
    out_grid_2 = AC.Dec21.parse_grid("23/67")
    out_grid_3 = AC.Dec21.parse_grid("89/cd")
    out_grid_4 = AC.Dec21.parse_grid("ab/ef")
    expected_out = [[out_grid_1, out_grid_2], [out_grid_3, out_grid_4]]

    assert AC.Dec21.break_up_grid(in_grid, 2) == expected_out
  end

  test "split a 6x6 grid into four 3x3 grids" do
    in_grid = AC.Dec21.parse_grid("0129ab/345cde/678fgh/ijkrst/lmnuvw/opqxyz")
    out_grid_1 = AC.Dec21.parse_grid("012/345/678")
    out_grid_2 = AC.Dec21.parse_grid("9ab/cde/fgh")
    out_grid_3 = AC.Dec21.parse_grid("ijk/lmn/opq")
    out_grid_4 = AC.Dec21.parse_grid("rst/uvw/xyz")
    expected_out = [[out_grid_1, out_grid_2], [out_grid_3, out_grid_4]]

    assert AC.Dec21.break_up_grid(in_grid, 3) == expected_out
  end

  test "split an 8x8 grid into four 4x4 grids" do
    in_grid = AC.Dec21.parse_grid(
      "01234567/89abcdef/ghijklmn/opqrstuv/wxyz0987/6543210z/yxwvutsr/qponmlkj")
    out_grid_1 = AC.Dec21.parse_grid("0123/89ab/ghij/opqr")
    out_grid_2 = AC.Dec21.parse_grid("4567/cdef/klmn/stuv")
    out_grid_3 = AC.Dec21.parse_grid("wxyz/6543/yxwv/qpon")
    out_grid_4 = AC.Dec21.parse_grid("0987/210z/utsr/mlkj")
    expected_out = [[out_grid_1, out_grid_2], [out_grid_3, out_grid_4]]

    assert AC.Dec21.break_up_grid(in_grid, 4) == expected_out
  end

  test "merge four 2x2 grids into a 4x4 grid" do
    in_grid_1 = AC.Dec21.parse_grid("01/45")
    in_grid_2 = AC.Dec21.parse_grid("23/67")
    in_grid_3 = AC.Dec21.parse_grid("89/cd")
    in_grid_4 = AC.Dec21.parse_grid("ab/ef")
    in_grids = [[in_grid_1, in_grid_2], [in_grid_3, in_grid_4]]
    expected_out = AC.Dec21.parse_grid("0123/4567/89ab/cdef")

    assert AC.Dec21.merge_grids(in_grids) == expected_out
  end

  test "merge four 3x3 grids into a 6x6 grid" do
    in_grid_1 = AC.Dec21.parse_grid("012/345/678")
    in_grid_2 = AC.Dec21.parse_grid("9ab/cde/fgh")
    in_grid_3 = AC.Dec21.parse_grid("ijk/lmn/opq")
    in_grid_4 = AC.Dec21.parse_grid("rst/uvw/xyz")
    in_grids = [[in_grid_1, in_grid_2], [in_grid_3, in_grid_4]]
    expected_out = AC.Dec21.parse_grid("0129ab/345cde/678fgh/ijkrst/lmnuvw/opqxyz")

    assert AC.Dec21.merge_grids(in_grids) == expected_out
  end

  test "merge four 4x4 grids into an 8x8 grid" do
    in_grid_1 = AC.Dec21.parse_grid("0123/89ab/ghij/opqr")
    in_grid_2 = AC.Dec21.parse_grid("4567/cdef/klmn/stuv")
    in_grid_3 = AC.Dec21.parse_grid("wxyz/6543/yxwv/qpon")
    in_grid_4 = AC.Dec21.parse_grid("0987/210z/utsr/mlkj")
    in_grids = [[in_grid_1, in_grid_2], [in_grid_3, in_grid_4]]
    expected_out = AC.Dec21.parse_grid(
      "01234567/89abcdef/ghijklmn/opqrstuv/wxyz0987/6543210z/yxwvutsr/qponmlkj")

    assert AC.Dec21.merge_grids(in_grids) == expected_out
  end

end
