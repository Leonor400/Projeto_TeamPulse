require('dotenv').config({ quiet: true });

const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// GET /api
app.get('/api', (req, res) => {
  res.json({
    nome: 'API Team Pulse',
    versao: '1.0.0',
    mensagem: 'Bem-vindo à API REST do Team Pulse.',
  });
});

// GET /api/health
app.get('/api/health', (req, res) => {
  res.json({
    estado: 'ok',
    mensagem: 'O servidor está a funcionar.',
    data: new Date().toISOString(),
  });
});

var atletasRouter = require('./routes/atletasRoutes');
app.use("/api/atletas", atletasRouter);

const PORT = Number(process.env.PORT) || 3000;

app.listen(PORT, () => {
  console.log(`Servidor Team Pulse a correr na porta ${PORT}`);
  console.log(`Teste: http://localhost:${PORT}/api/atletas`);
});
