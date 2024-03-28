defmodule MacroTest do
  use ExUnit.Case

  test "quote to ast" do
    # 每一个 ast node 都是一个三元组 {:symbol, env, children}
    dbg(quote do: z = x + y)
    dbg(quote do: z = add(x, y))
  end

  test "Macro escape value to ast" do
    assert Macro.escape([0 | [1, 2]]) == quote(do: [0, 1, 2])
  end

  test "unquote ast to expr" do
    fn_name = :add
    assert quote(do: unquote(fn_name)(x, y)) == quote(do: add(x, y))

    list = [1, 2]
    assert quote(do: [0, unquote_splicing(list)]) == quote(do: [0, 1, 2])
  end

  test "ast to_string" do
    ast = quote do: z = x + y
    assert Macro.to_string(ast) == "z = x + y"
  end

  # test "__ENV__" do
  #   dbg(__ENV__)
  # end
end
