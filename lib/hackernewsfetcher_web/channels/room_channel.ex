defmodule HackernewsfetcherWeb.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
  def handle_in("post_refresh", %{"body" => body}, socket) do
    broadcast!(socket, "post_refresh", %{body: body})
    Logger.info("handle_in")    
    {:noreply, socket}
  end
  def update_posts(data) do
    Logger.info("update posts")
    HackernewsfetcherWeb.Endpoint.broadcast("room:lobby", "post_refresh", %{data: data})
  end
end