defmodule HttpClient.Tesla do
  use Tesla
  @base_url "https://jsonplaceholder.typicode.com"

  plug Tesla.Middleware.BaseUrl, @base_url

  def fetch_all_completed_todos() do
    fetch_data()
    |> parse_body()
    |> get_completed_todos()
  end

  def fetch_data() do
    case get("/todos") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> body
      {:ok, %Tesla.Env{status: 404}} -> {:error, "URL not found. 404"}
      {:ok, %Tesla.Env{status: 500}} -> {:error, "Internal server error."}
    end
  end

  def parse_body(input) do
    Jason.decode(input)
  end

  def get_completed_todos({:ok, todos}) do
    todos
    |> Enum.filter(&(Map.get(&1, "completed")))
  end

end
