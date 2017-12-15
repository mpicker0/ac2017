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

  # Part 2
  @suffix [17, 31, 73, 47, 23]
  @rounds 64

  defmodule State do
    defstruct list: nil, pos: 0, skip: 0
  end

  def compute_dense_hash(input) do
    use Bitwise
    input
      |> Enum.chunk_every(16)
      |> Enum.map(fn(block) ->
           Enum.reduce(block, fn(i, acc) -> bxor(i, acc) end)
         end)
  end

  def hash_2([], state) do
    state
  end

  def hash_2([length | tail], %State{list: list, pos: pos, skip: skip}) do
    new_list = reverse_circular(list, pos, length)
    new_pos = rem(pos + length + skip, length(list))
    new_state = %State{list: new_list, pos: new_pos, skip: skip + 1}
    hash_2(tail, new_state)
  end

  def hash_times(lengths, state, rounds) do
    if rounds == 0 do
      state
    else
      new_state = hash_2(lengths, state)
      hash_times(lengths, new_state, rounds - 1)
    end
  end

  def hex_string(input) do
    input
      |> Enum.map(fn(i) -> Base.encode16(<<i>>, case: :lower) end)
      |> Enum.join
  end

  # This was added to support Day 14, where we are interested in the numerical
  # value of the hash rather than its hex representation
  def find_hash_binary(lengths) do
    initial_state = %State{list: Enum.to_list(0..255), pos: 0, skip: 0}

    processed_lengths = lengths
      |> to_charlist
      |> Enum.concat(@suffix)

    hash_times(processed_lengths, initial_state, @rounds).list
      |> compute_dense_hash
  end

  def find_hash(lengths) do
    find_hash_binary(lengths)
      |> hex_string
  end
end
