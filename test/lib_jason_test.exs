defmodule LibJasonTest do
  use ExUnit.Case

  defimpl Nestru.Decoder, for: DateTime do
    def decode_fields_hint(_empty_struct, _context, value) do
      case DateTime.from_iso8601(value) do
        {:ok, date_time, _offset} -> {:ok, date_time}
        error -> error
      end
    end
  end

  defmodule Category do
    @type t :: %__MODULE__{
            id: Integer.t(),
            name: String.t()
          }

    @derive Jason.Encoder
    @derive Nestru.Decoder
    defstruct id: 0, name: ""
  end

  defmodule Book do
    @type t :: %__MODULE__{
            id: Integer.t(),
            name: String.t(),
            price: Float.t(),
            categories: [Category.t()],
            created_at: DateTime.t()
          }

    @derive Jason.Encoder
    @derive {Nestru.Decoder, hint: %{categories: [Category], created_at: DateTime}}
    defstruct id: 0,
              name: "",
              price: 0.0,
              categories: [],
              created_at: nil
  end

  test "encode / decode" do
    book = %Book{created_at: DateTime.utc_now(), categories: [%Category{id: 1, name: "tech"}]}

    pretty_json = book |> Jason.encode!() |> Jason.Formatter.pretty_print()

    IO.puts(pretty_json)

    # json to map by jason
    map = pretty_json |> Jason.decode!()

    # map to struct by Nestru
    book2 = map |> Nestru.decode!(Book)

    assert book == book2
  end
end
