defmodule LibReqTest do
  use ExUnit.Case

  test "get" do
    resp = "https://httpbin.org/get" |> Req.get!()
    assert resp.status == 200
  end

  test "post json" do
    resp =
      "https://httpbin.org/post"
      |> Req.post!(json: %{foo: "bar"})

    assert resp.status == 200
  end

  test "post form" do
    resp =
      "https://httpbin.org/post"
      |> Req.post!(form: [foo: "bar", foo: "baz"])

    assert resp.status == 200
  end

  test "http proxy" do
    url = "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"

    proxy = {:http, "localhost", 55556, []}

    resp = Req.get!(url, connect_options: [proxy: proxy])

    assert resp.status == 200
    assert resp.body |> length() > 10
  end

  test "request builder" do
    url = "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"

    proxy = {:http, "localhost", 55556, []}

    # same as `Req.get!()`
    #
    req =
      Req.Request.new(method: :get, url: url)
      # NOTE: IMPORTANT 
      # add built-in request, response, error steps
      # register options keys for configuring those steps  (like :connect_options...)
      |> Req.Steps.attach()
      # set registered options key-value
      |> Req.Request.merge_options(connect_options: [proxy: proxy])

    resp = req |> Req.request!()

    assert resp.status == 200
    assert resp.body |> length() > 10
  end

  test "raise error when response http status >=400" do
    assert_raise(RuntimeError, fn ->
      Req.get!("https://httpbin.org/status/404", http_errors: :raise)
    end)
  end

  test "path param" do
    value = "hello_elixir"

    base64_value = Base.encode64(value)

    resp =
      "https://httpbin.org/base64/:value"
      |> Req.get!(path_params: [value: base64_value])

    assert resp.status == 200
    assert resp.body == value
  end
end
