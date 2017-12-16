defmodule AC.Dec15Test do
  use ExUnit.Case

  # values from online example
  @start_a 65
  @start_b 8921
  @factor_a AC.Dec15.get_factor_a
  @factor_b AC.Dec15.get_factor_b
  @multiple_a AC.Dec15.get_multiple_a
  @multiple_b AC.Dec15.get_multiple_b

  # problem 1
  test "example 1" do
    # this is just the very first part of the example
    assert AC.Dec15.final_count(@start_a, @start_b, 5) == 1

    # this is the entire example; it takes a long time to run (~1 minute)
    #assert AC.Dec15.final_count(@start_a, @start_b) == 588
  end

  # support
  test "generator a" do
    gen_a = AC.Dec15.generator(@start_a, @factor_a)
    answers = [1092455, 1181022009, 245556042, 1744312007, 1352636452]

    assert gen_a |> Stream.take(5) |> Enum.to_list == answers
  end

  test "generator b" do
    gen_b = AC.Dec15.generator(@start_b, @factor_b)
    answers = [430625591, 1233683848, 1431495498, 137874439, 285222916]

    assert gen_b |> Stream.take(5) |> Enum.to_list == answers
  end

  # problem 2
  test "example 1 (2)" do
    # this is just the very first part of the example
    assert AC.Dec15.final_count_2(@start_a, @start_b, 1055) == 0
    assert AC.Dec15.final_count_2(@start_a, @start_b, 1056) == 1

    # this is the entire example; it takes a long time to run (~1 minute)
    #assert AC.Dec15.final_count_2(@start_a, @start_b) == 309
  end

  # support
  test "filtering generator a" do
    gen_a = AC.Dec15.filtering_generator(@start_a, @factor_a, @multiple_a)
    answers = [1352636452, 1992081072, 530830436, 1980017072, 740335192]

    assert gen_a |> Stream.take(5) |> Enum.to_list == answers
  end

  test "filtering generator b" do
    gen_b = AC.Dec15.filtering_generator(@start_b, @factor_b, @multiple_b)
    answers = [1233683848, 862516352, 1159784568, 1616057672, 412269392]

    assert gen_b |> Stream.take(5) |> Enum.to_list == answers
  end
end
