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
end
