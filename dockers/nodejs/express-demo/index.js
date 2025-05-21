// Sample node.js web app for Docker demo
'use strict';

const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello world\n');
});

app.listen(3000, () => {
  console.log('Server is up on http://localhost:3000');
});