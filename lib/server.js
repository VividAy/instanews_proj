const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

let dataPackages = []; // This will store your data in memory for now

app.use(bodyParser.json());

app.post('/add', (req, res) => {
    const { i, des, title, link, tags } = req.body;
    const newPackage = { i, des, title, link, tags };
    dataPackages.push(newPackage);
    res.status(200).send('Data package added successfully');
});

app.get('/data', (req, res) => {
    res.status(200).json(dataPackages);
});

app.get('/', (req, res) => {
    res.send('Welcome to the Node.js server!');
});

app.listen(port, () => {
    console.log(`Node.js server is running at http://localhost:${port}`);
});
