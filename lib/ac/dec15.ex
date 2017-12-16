defmodule AC.Dec15 do

  @factor_a 16807
  @factor_b 48271
  @divisor  2147483647
  @limit 40_000_000

  # for testing
  def get_factor_a, do: @factor_a
  def get_factor_b, do: @factor_b

  # Part 1
  def generator(start, factor) do
    Stream.unfold(start, fn(x) ->
      {x, rem(x * factor, @divisor)}
    end)
    |> Stream.drop(1)  # "eat" the starting item
  end

  # take the lowest 16 bits of num
  def mask_16(num) do
    use Bitwise
    mask = (1 <<< 16) - 1
    band(num, mask)
  end

  def try_a() do
    gen_a = generator(65, @factor_a)
    gen_a
    |> Stream.take(5)
    |> Enum.to_list
  end

  def final_count(start_a, start_b, iterations \\ @limit) do
    gen_a = generator(start_a, @factor_a)
    gen_b = generator(start_b, @factor_b)
    Stream.zip(gen_a, gen_b)
    |> Stream.take(iterations)
    |> Stream.map(fn({a, b}) -> {mask_16(a), mask_16(b)} end)
    |> Stream.filter(fn({a, b}) -> a == b end)
    |> Enum.count
  end
end
