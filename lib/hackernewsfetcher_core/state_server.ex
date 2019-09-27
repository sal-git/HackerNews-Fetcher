defmodule HackernewsfetcherCore.StateServer do

    use GenServer
    require Logger
    import HackernewsfetcherCore.APIHelper

    def start_link(_), do: GenServer.start_link(__MODULE__, [], name: :state_server)
    def init(seed), do: {:ok, seed}

    def update_state({:ok, data}) do
        case get_pid() do
            nil -> {:error, "Unable to fetch data. State Server down."}
            pid -> GenServer.cast(pid, {:update, data})
        end
    end

    def update_state({:error, _reason}) do
        Logger.error("Unable to update the state.")
    end

    def get_state() do
        case get_pid() do
            nil -> {:error, "Unable to fetch data. State Server down."}
            pid -> GenServer.call(pid, :get)
        end
    end

    def get_post(id) do
        case get_pid() do
            nil -> {:error, "Unable to fetch data. State Server down."}
            pid -> GenServer.call(pid, {:get, id})
        end
    end

    defp get_pid(), do: GenServer.whereis(:state_server)

    def handle_cast({:update, data}, state) when data == state, do: {:noreply, data}

    def handle_cast({:update, data}, _state) do
        Logger.info("DATA CHANGE")
        HackernewsfetcherWeb.RoomChannel.update_posts(data)
        {:noreply, data}
    end

    def handle_call(:get, _from, state), do: {:reply, {:ok, state}, state}

    def handle_call({:get, id}, _from, state),
        do: {:reply, {:ok, Enum.filter(state, &(&1["id"] == id))}, state}


end