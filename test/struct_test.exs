defmodule StructTest do
  use ExUnit.Case

  defmodule Book do
    defstruct [:name, :price, tags: []]
  end

  test "init struct" do
    book = struct(Book, name: "the book", price: 11.98)
    assert book.name == "the book"
    assert book.price == 11.98
    assert book.tags == []
  end

  test "struct is a map" do
    book = struct(Book, name: "the book", price: 11.98)
    assert is_map(book)
  end

  test "struct get/set/update field (aka. Access)" do
    book = struct(Book, name: "the book", price: 11.98)

    book = put_in(book.name, "that book")
    assert book.name == "that book"

    book = put_in(book, [Access.key!(:name)], "my book")
    assert get_in(book, [Access.key!(:name)]) == "my book"

    book =
      update_in(book.tags, fn prev ->
        assert prev == []
        ["tech"]
      end)

    assert book.tags == ["tech"]
  end
end
