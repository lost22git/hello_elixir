defmodule FnTest do
  use ExUnit.Case

  test "fn match" do
    assert foo(1) == "match integer"
    assert foo(:bar) == "match any"
    assert foo("bar") == "match any"
  end

  test "anonymous fn" do
    # a_fn is an anonymous function
    a_fn = &foo/1
    assert is_function(a_fn)
    # `.(..)` call anonymous function
    assert a_fn.(1) == "match integer"

    b_fn = fn
      a, b when a > 0 and b > 0 -> rem(a, b)
      a, b -> Integer.mod(a, b)
    end

    assert is_function(b_fn)
    assert b_fn.(3, 2) == 1
    assert b_fn.(-3, 2) == 1
  end

  def foo(bar) when is_integer(bar) do
    _ = bar
    "match integer"
  end

  def foo(bar) do
    _ = bar
    "match any"
  end

  test "fn default param value" do
    assert default_param_value(10, 10, 10) == 10 + 10 + 10
    assert default_param_value(10, 10) == 1 + 10 + 10
  end

  def default_param_value(a \\ 1, b, c) do
    a + b + c
  end

  test "fn info" do
    info = Function.info(&foo/1)
    assert info[:name] == Function.info(&foo/1, :name) |> elem(1)
  end
end
