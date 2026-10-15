import React, { useEffect, useState } from 'react';
import { getAllMovies } from './api';
import './App.css';

function App() {
  const [movies, setMovies] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchMovies();
  }, []);

  const fetchMovies = async () => {
    try {
      const res = await getAllMovies();
      setMovies(res.data);
      setLoading(false);
    } catch (err) {
      setError('Failed to load movies from backend');
      setLoading(false);
    }
  };

  if (loading) return <h2 style={{ padding: 20 }}>Loading movies...</h2>;
  if (error) return <h2 style={{ padding: 20, color: 'red' }}>{error}</h2>;

  return (
    <div style={{ padding: 20 }}>
      <h1>🎬 MovieVerse</h1>
      <p>Connected to MySQL via Node.js backend ✅</p>
      <p><b>Total movies:</b> {movies.length}</p>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(220px, 1fr))', gap: 20, marginTop: 20 }}>
        {movies.map((movie) => (
          <div key={movie.id} style={{ border: '1px solid #ddd', borderRadius: 8, padding: 12, background: '#fafafa' }}>
            {movie.image_url && (
              <img
                src={movie.image_url}
                alt={movie.name}
                style={{ width: '100%', borderRadius: 6 }}
              />
            )}
            <h3 style={{ marginTop: 8 }}>{movie.name}</h3>
            <p>⭐ {movie.rating ?? 'N/A'}</p>
            <p style={{ fontSize: 12, color: '#666' }}>{movie.status}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;