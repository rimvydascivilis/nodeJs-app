import express from 'express';
import bodyParse from 'body-parser';
import { router as helloRouter } from './hello.js';

export function application(port) {
  const app = express();
  app.use(bodyParse.json());

  app.use('/hello', helloRouter);

  app.get('/health', (req, res) => {
    res.send({ status: 'OK' });
  });

  app.get('*', (req, res) => {
    res.status(404).send({ message: 'Not Found' });
  });

  return app.listen(port, () => {
    console.log(`App listening on port ${port}`);
  });
}
