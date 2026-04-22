const app = require('./app');

const PORT = Number(process.env.PORT) || 3000;

// app.listen(PORT, () => {
//   console.log(`Safe Zone SOS backend listening on port ${PORT}`);
// });

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Safe Zone SOS backend listening on port ${PORT}`);
});