import express from 'express';

const router = express.Router();

router.get('/', (req, res) => {
  res.send({ message: 'Hello World! v2' });
});

router.post('/', (req, res) => {
  res.send({ message: `Hello ${req.body.name}!` });
});

export { router };
