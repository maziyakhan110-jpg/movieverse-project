const express = require('express');
const cors = require('cors');
const pool = require('./db');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// ROOT - check server is running
app.get('/', (req, res) => {
  res.json({ message: 'MovieVerse Backend is running' });
});

// GET ALL MOVIES
app.get('/api/movies', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM shows ORDER BY id');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET ONE MOVIE BY ID
app.get('/api/movies/:id', async (req, res) => {
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM shows WHERE id = ?',
      [req.params.id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Movie not found' });
    }
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ADD NEW MOVIE
app.post('/api/movies', async (req, res) => {
  const { tvmaze_id, name, summary, rating, image_url, language, premiered, status, genre_id } = req.body;
  if (!name) {
    return res.status(400).json({ error: 'Name is required' });
  }
  try {
    const [result] = await pool.execute(
      `INSERT INTO shows (tvmaze_id, name, summary, rating, image_url, language, premiered, status, genre_id)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [tvmaze_id, name, summary, rating, image_url, language, premiered, status, genre_id]
    );
    const [newMovie] = await pool.execute(
      'SELECT * FROM shows WHERE id = ?',
      [result.insertId]
    );
    res.status(201).json(newMovie[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Backend running at http://localhost:${PORT}`);
});