
import React, { useEffect, useState } from 'react';

function App() {
  const [todos, setTodos] = useState([]);
  const [newTodo, setNewTodo] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Fetch todos on load
  useEffect(() => {
    fetchTodos();
  }, []);

  async function fetchTodos() {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch('/api/todos');
      if (!res.ok) throw new Error('Failed to fetch');
      const data = await res.json();
      setTodos(data);
    } catch (e) {
      setError('Could not load todos');
    } finally {
      setLoading(false);
    }
  }

  async function addTodo(e) {
    e.preventDefault();
    if (!newTodo.trim()) return;
    setLoading(true);
    setError(null);
    try {
      const res = await fetch('/api/todos', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title: newTodo })
      });
      if (!res.ok) throw new Error('Failed to add');
      setNewTodo('');
      fetchTodos();
    } catch (e) {
      setError('Could not add todo');
    } finally {
      setLoading(false);
    }
  }

  async function deleteTodo(id) {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch(`/api/todos/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Failed to delete');
      fetchTodos();
    } catch (e) {
      setError('Could not delete todo');
    } finally {
      setLoading(false);
    }
  }

  // For minimalism, no toggle-complete if not in backend, just list/delete/add
  return (
    <div style={{ maxWidth: 400, margin: '2rem auto', fontFamily: 'sans-serif' }}>
      <h2>Todo List</h2>
      <form onSubmit={addTodo} style={{ display: 'flex', gap: 8 }}>
        <input
          value={newTodo}
          onChange={e => setNewTodo(e.target.value)}
          placeholder="Add a todo..."
          style={{ flex: 1 }}
          disabled={loading}
        />
        <button type="submit" disabled={loading || !newTodo.trim()}>Add</button>
      </form>
      {error && <div style={{ color: 'red', marginTop: 8 }}>{error}</div>}
      <ul style={{ listStyle: 'none', padding: 0, marginTop: 16 }}>
        {loading ? <li>Loading...</li> :
          todos.length === 0 ? <li>No todos yet</li> :
            todos.map(todo => (
              <li key={todo.id} style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                <span style={{ flex: 1 }}>{todo.title}</span>
                <button onClick={() => deleteTodo(todo.id)} disabled={loading}>Delete</button>
              </li>
            ))}
      </ul>
    </div>
  );
}

export default App;
