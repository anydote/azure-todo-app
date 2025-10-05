import os
import pytest
from api.todos import TodoItem


def test_todoitem_fields():
    title = "Test task"

    todo = TodoItem(title=title)

    assert todo.PartitionKey == "todos"
    assert isinstance(todo.RowKey, str)
    assert todo.title == title
    assert len(todo.title) <= 200
    assert todo.createdAt is not None
    assert todo.id == todo.RowKey


def test_todoitem_to_dict():
    title = "Test task"
    todo = TodoItem(title=title)

    d = todo.to_dict()

    assert d["PartitionKey"] == "todos"
    assert d["id"] == todo.RowKey
    assert d["title"] == title
    assert d["createdAt"] == todo.createdAt
