defmodule MathTest do
  use ExUnit.Case

  test "div float / truncate / floor" do
    # float
    assert 3 / 2 == 1.5
    assert -3 / 2 == -1.5

    # truncate
    assert div(3, 2) == 1
    assert div(-3, 2) === -1

    # floor
    assert Integer.floor_div(3, 2) == 1
    assert Integer.floor_div(-3, 2) == -2
  end

  test "rem / mod" do
    # rem: M - (div(M, N) * N)
    assert rem(3, 2) == 1
    assert rem(-3, 2) == -1

    # mod: M - (floor_div(M, N) * N)
    assert Integer.mod(3, 2) == 1
    assert Integer.mod(-3, 2) == 1
  end

  test "overflow" do
  end
end
