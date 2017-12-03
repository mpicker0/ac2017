defmodule AC.Dec03 do
  #import Enum

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

  def for_thing_2 do
    for times1 <- 1..100,
    do: [
      List.duplicate("incx", times1),
      List.duplicate("incy", times1),
      List.duplicate("decx", times1+1),
      List.duplicate("decy", times1+1)
    ]
    |> List.flatten
  end

  def test_for do
    for_thing() |> List.flatten
  end

  def test_stream_cycle() do
    Stream.cycle([:l, :d, :r, :u])
  end

  def even_stream() do
    Stream.iterate(0, & &1 + 2)
  end

  def test_thing_3() do
    #for times <- even_stream(),
    import List
    result = flatten(
      for times <- Enum.to_list(even_stream() |> Enum.take(600)),
      do: duplicate(:l, times) ++ duplicate(:d, times) ++ duplicate(:r, times + 1) ++ duplicate(:u, times + 1)
    )
    IO.puts(inspect(result))
    result
  end

  def test_it(location) do
    #:io_lib.format "Size is: ~B", [test_thing_3().size()]
    result = test_thing_3()
    if is_list(result) do
      IO.puts("it's a list")
      IO.puts(:io_lib.format "list size is: ~B", [length(result)])
      IO.puts(:io_lib.format "I want the first ~B", [location])
    end

    mymap =
      result
      |> Enum.take(location - 1)
      |> IO.inspect()
      |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

     IO.puts(inspect(mymap))

     # TODO if no movement component in map, default to zero
     dist_x = abs(Map.get(mymap, :r, 0) - Map.get(mymap, :l, 0))
     dist_y = abs(Map.get(mymap, :u, 0) - Map.get(mymap, :d, 0))
     final_answer = dist_x + dist_y
     IO.puts(:io_lib.format "Final answer: ~B", [final_answer])
     final_answer
  end

  # User-facing functions

  def distance(location) do
    test_it(location)
  end

end
