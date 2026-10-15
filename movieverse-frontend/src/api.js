import axios from 'axios';

const API = axios.create({
  baseURL: 'http://localhost:5000/api',
});

export const getAllMovies = () => API.get('/movies');
export const getMovieById = (id) => API.get(`/movies/${id}`);
export const addMovie = (movie) => API.post('/movies', movie);

export default API;