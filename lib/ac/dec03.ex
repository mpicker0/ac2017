defmodule AC.Dec03 do
  import Enum

  def generator() do
    Stream.iterate(3, fn(x) -> x + 2 end)
  end

  def invoke_generator() do
    generator() |> Enum.take(5)
  end

  def for_thing do
    for inst1 <- ["incx", "incy"],
        inst2 <- ["dexy", "decx"],
    do: [inst1, inst2]
  end

  def test_for do
    for_thing |> List.flatten
  end

  # User-facing functions

  def distance(location) do
    -1  # TODO implement
  end

end
