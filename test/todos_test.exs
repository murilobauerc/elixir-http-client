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

  test "it creates a todo" do
    created_todo = Todos.create_todo(100, "Buy tickets to Sao Paulo", false)

    assert %{
      "completed" => false,
      "id" => 201,
      "title" => "Buy tickets to Sao Paulo",
      "user_id" => 100
    } == created_todo
  end

  test "it fails to create a todo when user_id is not an integer" do
    created_todo = Todos.create_todo("not a number", "Buy tickets to Sao Paulo", false)

    assert {:error, "Something went wrong."} == created_todo
  end

  test "it fails to create a todo when completed status is not a boolean" do
    created_todo = Todos.create_todo(5, "Internacional to win a championship", "just a string")

    assert {:error, "Something went wrong."} == created_todo
  end

  test "it deletes a todo by its id" do
    todo_to_be_deleted = Todos.delete_todo(1)

    assert "Deleted the record with id: 1" == todo_to_be_deleted
  end

  test "it fails to delete a todo that is not an integer" do
    todo_to_be_deleted = Todos.delete_todo("a")

    assert {:error, "Something went wrong."} == todo_to_be_deleted
  end
end
