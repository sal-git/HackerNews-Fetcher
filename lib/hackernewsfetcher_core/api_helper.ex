defmodule HackernewsfetcherCore.APIHelper do

    def get_top_posts() do
        :httpc.request(:get, {'https://hacker-news.firebaseio.com/v0/topstories.json', []}, [], [])
        |> parse_response
        |> limit_posts
    end

    def get_post(id) do
        :httpc.request(:get, {'https://hacker-news.firebaseio.com/v0/item/#{id}.json', []}, [], [])
        |> parse_response
    end

    def combine_with_post_content({:ok, ids}) do
        data =
            Parallel.pmap(ids, &get_post(&1))
            |> Enum.map(fn
                {:ok, post} ->
                post

                {:error, _reason} ->
                # Do something with the error maybe? Probably doesnt matter since next iteration will upate state
                nil
            end)
            |> Enum.filter(&(&1 != nil))

        {:ok, data}
    end

    def combine_with_post_content({:error, reason}), do: {:error, reason}

    @doc """
    Reduces the post count to 50
    """
    def limit_posts({:ok, posts}), do: {:ok, Enum.take(posts, 50)}

    def limit_posts({:error, reason}), do: {:error, reason}

    @doc """
    Parse and encode the http response
    """
    def parse_response({:ok, {{_, _, _}, _headers, body}}) do
        body
        |> Jason.decode()
    end

    def parse_response({:error, reason}), do: {:error, reason}
    
end