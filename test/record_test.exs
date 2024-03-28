defmodule RecordTest do
  use ExUnit.Case

  defmodule Book do
    require Record
    Record.defrecord(:book, name: "", price: 0)
  end

  test "record create / getter / setter" do
    import Book
    # create
    a = book()

    # Record is a Tuple { atom , ... }
    assert is_tuple(a)
    assert a == {:book, "", 0}

    # getter/setter
    # NOTE: the keyword list must be literal
    new_name = "that book"
    a = book(a, name: new_name, price: 11)
    assert a == {:book, "that book", 11}
  end

  test "record <=> keyword list" do
    import Book

    # NOTE: the keyword list must be literal
    a = book(name: "the book", price: 10)

    assert book(a) == [name: "the book", price: 10]
  end
end
