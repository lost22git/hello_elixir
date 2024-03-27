defmodule StringTest do
  use ExUnit.Case

  test "string is a binary " do
    assert "你好" == <<"你好"::utf8>>

    assert is_binary("你好")

    # of course, is a bitstring
    assert is_bitstring("你好")
  end

  test "string <=> charlist" do
    assert String.to_charlist("你好") == ~c"你好"
    assert "你好" == to_string(~c"你好")

    # charlist is a codepoint list
    assert ~c"你好" == [?你, ?好]
    assert is_list(~c"你好")

    # ?你 is a codepoint
    assert is_integer(?你)
  end

  test "string concat" do
    assert "你好, " <> "elixir" == "你好, elixir"
  end

  test "string interpolate" do
    name = "elixir"
    assert "你好, elixir" == "你好, #{name}"
  end

  test "string length /  byte_size" do
    assert String.length("你好") == 2
    assert byte_size("你好") == 2 * 3
  end

  test "string codepoints and grapheme" do
    # NOTE: please view it by an editor which supports grapheme cluster
    s = "你好, 👨‍🚀"

    assert String.codepoints(s) == ["你", "好", ",", " ", "👨", "‍", "🚀"]
    assert String.graphemes(s) == ["你", "好", ",", " ", "👨‍🚀"]
  end

  test "string without escaping quotes" do
    name = "elixir"
    # 你好, "elixir"
    # ~s
    assert "你好, \"elixir\"" == ~s(你好, "#{name}")
    assert "你好, \"elixir\"" == ~s{你好, "#{name}"}
    assert "你好, \"elixir\"" == ~s/你好, "#{name}"/
    assert "你好, \"elixir\"" == ~s'你好, "#{name}"'

    # ~w
    assert ["你好", "\"elixir\""] == ~w(你好 "#{name}")
  end

  test "string multilines" do
    name = "elixir"

    json = """
    {
      "hello": "#{name}"
    }
    """

    assert "{\n  \"hello\": \"elixir\"\n}\n" == json
  end

  test "string split" do
    s = "你好, elixir"

    assert String.split(s, [",", " "]) == ["你好", "", "elixir"]

    assert String.split(s, [",", " "], trim: true) == ["你好", "elixir"]

    assert String.split(s, [",", " "], parts: 2) == ["你好", " elixir"]
  end

  test "string replace" do
    assert String.replace("你好, elixir", "你好", "hello") == "hello, elixir"
  end

  test "string slice" do
    # range: from..to//step
    assert String.slice("hello", 2..3) == "ll"
    assert String.slice("hello", 2..999) == "llo"
    assert String.slice("hello", 2..999//2) == "lo"
    assert String.slice("hello", 2..-2//1) == "ll"
  end

  # test "string format" do
  #   # https://www.erlang.org/doc/man/io.html#type-format
  #   IO.puts(:io_lib.format("hello ~10s ~n", ["👻"]))
  # end

  test "string <=> date time" do
    assert ~U"2022-02-02T22:22:22Z" ==
             (case(DateTime.from_iso8601("2022-02-02T22:22:22Z")) do
                {:ok, datetime, _tz} -> datetime
                {:error, _} -> DateTime.utc_now()
              end)
  end
end
