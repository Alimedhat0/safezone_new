require('dotenv').config();

const express = require('express');
const cors = require('cors');

const sosRoutes = require('./routes/sosRoutes');
const { notFoundHandler, errorHandler } = require('./middleware/errorHandler');

const app = express();

app.use(
  cors({
    origin: process.env.CORS_ORIGIN || '*',
  }),
);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Safe Zone SOS backend is running.',
  });
});

app.use('/api', sosRoutes);
app.use(notFoundHandler);
app.use(errorHandler);

module.exports = app;
