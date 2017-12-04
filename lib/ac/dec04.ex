defmodule AC.Dec04 do
  import Enum

  def valid_passphrase(passphrase) do
    # break into words
    matching_words = String.split(passphrase)
    |> reduce(%{}, fn (x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Map.values
    |> find(0, fn(count) -> count > 1 end)
    matching_words == 0
  end

  def valid_passphrases(filename) do
    count = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn (line) -> valid_passphrase(line) end)
    |> Enum.count(fn (item) -> item end)
    count
  end

  def canonicalize_word(word) do
    Enum.sort(String.codepoints(word))
  end

  def valid_passphrase_2(passphrase) do
    matching_words = String.split(passphrase)
    |> map(fn(w) -> canonicalize_word(w) end)
    |> reduce(%{}, fn (x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Map.values
    |> find(0, fn(count) -> count > 1 end)
    matching_words == 0
  end

  def valid_passphrases_2(filename) do
    count = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn (line) -> valid_passphrase_2(line) end)
    |> Enum.count(fn (item) -> item end)
    count
  end
end
