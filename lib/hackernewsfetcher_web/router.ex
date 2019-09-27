defmodule HackernewsfetcherWeb.Router do
  use HackernewsfetcherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HackernewsfetcherWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", HackernewsfetcherWeb do
    pipe_through :api
    get("/get_top_posts", ApiController, :get_top_posts)
    get("/get_single_post", ApiController, :get_single_post)
  end
end
