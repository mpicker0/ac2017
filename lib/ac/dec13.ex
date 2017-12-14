defmodule AC.Dec13 do

  defmodule Layer do
    defstruct depth: nil, range: nil, scanner_location: 0, direction: 1
  end

  def parse_line(line) do
    [d,r|_] = String.split(line, ": ")
    %Layer{depth: String.to_integer(d), range: String.to_integer(r)}
  end

  # Part 1
  def move_scanners(firewall) do
    Enum.into(firewall, %{}, fn({k,v}) ->
      {new_direction, new_scanner_location} = cond do
        v.range == 1 ->
          {v.direction, v.scanner_location}

        v.scanner_location + v.direction < 0 or
          v.scanner_location + v.direction == v.range ->
            {-v.direction, v.scanner_location - v.direction}

        true ->
          {v.direction, v.scanner_location + v.direction}
      end
      {k, %{v | scanner_location: new_scanner_location, direction: new_direction}}
    end)
  end

  def find_severity_r(_, step, firewall_length, severity, _)
  when step > firewall_length do
    severity
  end

  # count_zero specifies whether we should count a hit in layer zero, which we
  # need to for part 2.  This skews the severity score in part 2, but it doesn't
  # matter since we're only interested when there are no collisions.
  def find_severity_r(firewall, step, firewall_length, severity, count_zero) do
    # In the current firewall layer (i.e. step), is the scanner present?
    # If so, add to the severity
    new_severity = cond do
      !Map.has_key?(firewall, step) ->
        severity
      Map.get(firewall, step).scanner_location == 0 ->
        severity + (step * Map.get(firewall, step).range) + (if (step == 0 and count_zero), do: 1, else: 0)
      true ->
        severity
    end

    find_severity_r(move_scanners(firewall), step + 1, firewall_length, new_severity, count_zero)
  end

  def get_firewall(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce(%{}, fn(layer, acc) -> Map.put(acc, layer.depth, layer) end)
  end

  def find_severity(filename) do
    firewall = get_firewall(filename)
    {firewall_length, _} = Enum.max_by(firewall, fn({k,_}) -> k end)
    find_severity_r(firewall, 0, firewall_length, 0, :false)
  end

  # Part 2

  # Opportunity to improve:  how far back should we go?  Just making something
  # up.  Preferably we'd only go back until we found one with zero severity,
  # then stop.
  # This is extremely inefficient for a large firewall.  The approach to this
  # problem needs to be rethought.
  @back_to -20
  def find_shortest_delay_r(firewall, firewall_length) do
    delays = for delay <- 0..@back_to,
      severity = find_severity_r(firewall, delay, firewall_length, 0, :true),
      do: {delay, severity}
    #Enum.map(delays, fn({delay, severity}) -> IO.puts("delay: #{delay}, severity: #{severity}") end)
    {delay, _} = Enum.find(delays, fn({_, severity}) -> severity == 0 end)
    -delay
  end

  def find_shortest_delay(filename) do
    firewall = get_firewall(filename)
    {firewall_length, _} = Enum.max_by(firewall, fn({k,_}) -> k end)

    # The concept of "delay" means we start "step" further and further back and
    # keep making the run with each value until we end up with a severity of
    # zero
    find_shortest_delay_r(firewall, firewall_length)
  end

end
