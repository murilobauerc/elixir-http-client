defmodule Todos do
  use Tesla
  @base_url "https://jsonplaceholder.typicode.com"

  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON

  @doc """
    Returns a list of all todos.
  """
  def get_all_todos() do
    case get("/todos") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> body
      {:ok, %Tesla.Env{status: 404}} -> {:error, "URL not found. 404."}
      {:ok, %Tesla.Env{status: 500}} -> {:error, "Internal server error."}
    end
  end


  @doc """
    Gets only a specific quantity of todos given by the user.
    The `quantity` argument indicates how many todos should be listed.

  ## Examples

      iex> Todos.get_quantity_todos(3)
      [
        %{
          "completed" => false,
          "id" => 1,
          "title" => "delectus aut autem",
          "userId" => 1
        },
        %{
          "completed" => false,
          "id" => 2,
          "title" => "quis ut nam facilis et officia qui",
          "userId" => 1
        },
        %{
          "completed" => false,
          "id" => 3,
          "title" => "fugiat veniam minus",
          "userId" => 1
        }
      ]
  """
  def get_quantity_todos(quantity) do
    case get("/todos") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> Enum.take(body, quantity)
      {:ok, %Tesla.Env{status: 404}} -> {:error, "URL not found. 404."}
      {:ok, %Tesla.Env{status: 500}} -> {:error, "Internal server error."}
    end
  end

  @doc """
    Returns a todo given a todo_id.
  """
  def get_todo_id(id) do
    case get("/todos/#{id}") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> body
      {:ok, %Tesla.Env{status: 404}} -> {:error, "Todo #{id} does not exists."}
    end
  end

  @doc """
    Given user_id, title and completed returns a created todo.
  """
  def create_todo(user_id, title, completed) do
    request_body = %{user_id: user_id, title: title, completed: completed}
    case post("/todos", request_body) do
      {:ok, %Tesla.Env{status: 201, body: body}} -> body
      {:ok, %Tesla.Env{status: 404}} -> {:error, "Something went wrong when creating the todo."}
      {:ok, %Tesla.Env{status: 500}} -> {:error, "Internal server error"}
    end
  end

  @doc """
    Given an id, deletes the todo.
  """
  def delete_todo(id) do
    case delete("/todos/#{id}") do
      {:ok, %Tesla.Env{status: 200}} -> "Deleted the record with id: #{id}"
      {:ok, %Tesla.Env{status: 404}} -> {:error, "Todo #{id} does not exists."}
      {:ok, %Tesla.Env{status: 500}} -> {:error, "Internal Server Error."}
    end
  end

  @doc """
    Given an id, updates the todo.
  """
  def update_todo(user_id, title, completed) do
    request_body = %{user_id: user_id, title: title, completed: completed}
    case put("/todos/#{user_id}", request_body) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> body
      {:ok, %Tesla.Env{status: 404}} -> {:error, "Something went wrong to update the todo."}
      {:ok, %Tesla.Env{status: 500}} -> {:error, "Internal Server Error."}
    end
  end

  @doc """
    Returns a parsed detailed list of all todos completed.
  """
  def list_all_by_completed_todos() do
    get_all_todos()
    |> match_completed_todos()
  end

  def match_completed_todos(todos) do
    todos
    |> Enum.filter(&(Map.get(&1, "completed")))
  end

end
