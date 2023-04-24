import * as testing from './application.js';
const fetch = require('node-fetch');

describe('application.test', () => {
  let server;

  beforeAll(() => {
    server = testing.application(3000);
  });

  afterAll(() => {
    server.close();
  });

  it('should return a 200 status and "OK" message when requesting the /health endpoint', async () => {
    const response = await fetch('http://localhost:3000/health');
    const json = await response.json();
    
    expect(response.status).toBe(200);
    expect(json).toEqual({ status: 'OK' });
  });

  it('should return a 404 status and "Not Found" message when requesting an unknown endpoint', async () => {
    const response = await fetch('http://localhost:3000/unknown');
    const json = await response.json();

    expect(response.status).toBe(404);
    expect(json).toEqual({ message: 'Not Found' });
  });
  
  it('should return a "Hello World!" message when requesting the /hello endpoint with GET', async () => {
    const response = await fetch('http://localhost:3000/hello');
    const json = await response.json();

    expect(json).toEqual({ message: 'Hello World! v2' });
  });

  it('should return a "Hello John!" message when sending a POST request to the /hello endpoint with {"name": "John"}', async () => {
    const response = await fetch('http://localhost:3000/hello', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: 'John' }),
    });
    const json = await response.json();

    expect(json).toEqual({ message: 'Hello John!' });
  });
});
