defmodule AC.Dec09 do

  defmodule State do
    defstruct group_depth: 0, in_garbage?: :false, ignore_next?: :false,
              group_scores: [], garbage_chars: 0
  end

  # Part 1

  def process_sample([], state) do
    state
  end

  def process_sample([this_char | tail], state) do
    #IO.puts("------- this char and current state: ------")
    #IO.inspect this_char
    #IO.inspect state

    # process this character
    cond do
      state.ignore_next? ->
        process_sample(tail, %{state | ignore_next?: :false})
      state.in_garbage? ->
        new_state = case this_char do
          "!" -> %{state | ignore_next?: :true}
          ">" -> %{state | in_garbage?: :false}
          _   -> %{state | garbage_chars: state.garbage_chars + 1}
        end
        process_sample(tail, new_state)
      true ->
        new_state = case this_char do
          "{" -> %{state | group_depth: state.group_depth + 1}
          "}" -> %{state | group_depth: state.group_depth - 1,
                           group_scores: [state.group_depth | state.group_scores] }
          "<" -> %{state | in_garbage?: :true}
          "!" -> %{state | ignore_next?: :true}
          _   -> state
        end
        process_sample(tail, new_state)
    end
  end

  def map_sample(sample) do
    sample |> String.graphemes |> process_sample(%State{})
  end

  def total_score_in_sample(sample) do
    map_sample(sample).group_scores |> Enum.sum
  end

  def find_total_group_score(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
    |> hd
    |> total_score_in_sample
  end

  # Part 2
  def count_garbage(sample) do
    map_sample(sample).garbage_chars
  end

  def find_total_garbage_chars(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
    |> hd
    |> count_garbage
  end

end
