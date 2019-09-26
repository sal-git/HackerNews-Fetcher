defmodule HackernewsfetcherWeb.PageController do
  use HackernewsfetcherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
