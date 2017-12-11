defmodule AC.Dec10 do

  # Part 1

  # Reverse the section of list 'list' starting at index 'start' for 'count'
  # characters.  The list is circular; if 'count' would go beyond the end of
  # the list, it is considered to have wrapped around.
  def reverse_circular(list, start, count) do
    len = length(list)
    if start + count >= len do
      # Don't expect this to happen, but just in case
      if start + count > len * 2 do
        raise "count is too great!  Can't handle this reverse!"
      end
      doubled = list ++ list
        |> Enum.reverse_slice(start, count)
      Enum.slice(doubled, len, len - (len - start)) ++ Enum.slice(doubled, start, len - start)
    else
      Enum.reverse_slice(list, start, count)
    end
  end

  def hash([], list, _, _) do
    list
  end

  def hash([length | tail], list, pos, skip) do
    new_list = reverse_circular(list, pos, length)
    new_pos = rem(pos + length + skip, length(list))
    hash(tail, new_list, new_pos, skip + 1)
  end

  def find_product(lengths, list_range \\ 0..255) do
    String.split(lengths, ",")
      |> Enum.map(fn(s) -> String.to_integer(s) end)
      |> hash(Enum.to_list(list_range), 0, 0)
      |> Enum.take(2)
      |> Enum.reduce(1, fn(num, acc) -> num * acc end)
  end
end
