defmodule AC.Dec01 do
  import Enum

  def digits_as_list(digits) do
    import String
    map(codepoints(digits), fn(i) -> to_integer(i) end)
  end

  # Operation:  I generate two lists, one is the initial list of digits and one
  # is the same list offset by one.  I then zip them together, filter for the
  # matching elements, and sum them up.
  #
  # The code for both these problems is largely the same; the only difference
  # is the amount of offset (one vs. half the size of the list).  This could be
  # abstracted into a single function.
  def solve_capcha(capcha) do
    digits = digits_as_list(capcha)
    solution = zip(
      digits,
      concat(
        slice(digits, 1, length(digits) - 1),
        digits ++ [hd(digits)]
      )
    )
      |> filter(fn pair -> elem(pair, 0) == elem(pair, 1) end)
      |> map(fn(x) -> elem(x, 0) end)
      |> sum
    solution
  end

  def solve_capcha_2(capcha) do
    digits = digits_as_list(capcha)
    half = div(length(digits), 2)
    zipped = zip(
      digits,
      concat(
        slice(digits, half, half),
        slice(digits, 0, half)
      )
    )
    solution = zipped
      |> filter(fn pair -> elem(pair, 0) == elem(pair, 1) end)
      |> map(fn(x) -> elem(x, 0) end)
      |> sum
    solution
  end
end
