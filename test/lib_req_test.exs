defmodule LibJasonTest do
  use ExUnit.Case

  test "get" do
    resp = Req.get!("https://httpbin.org/get")
    assert resp.status == 200
  end

  test "post json" do
    resp = Req.post!("https://httpbin.org/post", json: %{foo: "bar"})
    assert resp.status == 200
  end

  test "post form" do
    resp = Req.post!("https://httpbin.org/post", form: [foo: "bar", foo: "baz"])
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
end
