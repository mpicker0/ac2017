defmodule AC.Dec25Test do
  use ExUnit.Case
  alias AC.Dec25.Instruction, as: Instruction

  def get_instructiondefs do
    %{
      :a => %{
        0 => %Instruction{write_value: 1, move_to: :right, next_machine_state: :b},
        1 => %Instruction{write_value: 0, move_to: :left,  next_machine_state: :b}
      },
      :b => %{
        0 => %Instruction{write_value: 1, move_to: :left,  next_machine_state: :a},
        1 => %Instruction{write_value: 1, move_to: :right, next_machine_state: :a}
      }
    }
  end

  # problem 1
  test "example 1" do
    assert AC.Dec25.find_checksum(get_instructiondefs(), 6) == 3
  end

end
