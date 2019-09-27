defmodule HackernewsfetcherWeb.ApiController do
    use HackernewsfetcherWeb, :controller

    def get_top_posts(conn, _params) do
        with {:ok, data} <- HackernewsfetcherCore.StateServer.get_state() do
            json(conn, data)
        end
    end

    def get_single_post(conn, %{"id" => id} = _params) do
        with {int_id, _} <- Integer.parse(id),
            {:ok, data} <- HackernewsfetcherCore.StateServer.get_single_post(int_id) do
            json(conn, data)
        end
    end
end