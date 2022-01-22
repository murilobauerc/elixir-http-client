defmodule HttpClient.Tesla do
  use Tesla
  @base_url "https://jsonplaceholder.typicode.com"

  plug Tesla.Middleware.BaseUrl, @base_url

  def all_todos() do
    case get("/todos") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> body
      {:ok, %Tesla.Env{status: 404}} -> {:error, "URL not found. 404"}
      {:ok, %Tesla.Env{status: 500}} -> {:error, "Internal server error."}
    end
  end

  def todo_id(id) do
    case get("/todos/#{id}") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> body
      {:ok, %Tesla.Env{status: 404}} -> {:error, "URL not found. 404"}
    end
  end

  @doc """
    Returns parsed detailed todo given a todo_id.
  """
  def get_by_todo_id(id) do
    id
    |> todo_id()
    |> parse_body()
    |> filter_todo_id()
  end

  @doc """
    Returns a parsed detailed list of all todos completed.
  """
  def list_all_by_completed_todos() do
    all_todos()
    |> parse_body()
    |> filter_completed_todos()
  end

  def parse_body(input) do
    Jason.decode(input)
  end

  def filter_todo_id({:ok, todo}) do
    todo
  end

  def filter_completed_todos({:ok, todos}) do
    todos
    |> Enum.filter(&(Map.get(&1, "completed")))
  end

end
