
defmodule LibTeslaTest do
  use ExUnit.Case

  defmodule HackernewsClient do
    use Tesla
    adapter Tesla.Adapter.Hackney
    plug Tesla.Middleware.Opts, adapter: [proxy: {'127.0.0.1', 55556}]
    plug Tesla.Middleware.Headers, [
      {"user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:125.0) Gecko/20100101 Firefox/125.0"}
    ]
    plug Tesla.Middleware.JSON
    plug Tesla.Middleware.FormUrlencoded
    plug Tesla.Middleware.PathParams
    plug Tesla.Middleware.Logger
    
    def get_topstories do
      get "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"
    end
  end

  test "hackernews client get_topstories" do
    resp = HackernewsClient.get_topstories()
    resp |> dbg()
  end
end
