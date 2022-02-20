defmodule TodosTest do
  use ExUnit.Case
  doctest Todos

  test "gets first 3 todos" do
    quantity_todos = Todos.get_quantity_todos(3)

    assert %{
      "completed" => false,
      "id" => 1,
      "title" => "delectus aut autem",
      "userId" => 1
    } == Enum.at(quantity_todos, 0)

    assert %{
      "completed" => false,
      "id" => 2,
      "title" => "quis ut nam facilis et officia qui",
      "userId" => 1
    } == Enum.at(quantity_todos, 1)

    assert %{
      "completed" => false,
      "id" => 3,
      "title" => "fugiat veniam minus",
      "userId" => 1
    } == Enum.at(quantity_todos, 2)
  end

  test "get a todo by its id" do
    todo_by_id = Todos.get_todo_id(1)

    assert todo_by_id == %{
      "completed" => false,
      "id" => 1,
      "title" => "delectus aut autem",
      "userId" => 1
    }
  end

  test "it returns error when tries to get an unexistent id" do
    assert {:error, reason} = Todos.get_todo_id(99999)
  end
end
