const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 8088;

const server = http.createServer((req, res) => {
  let filePath = path.join(__dirname, req.url === '/' ? 'index.html' : req.url);

  fs.readFile(filePath, (err, content) => {
    if (err) {
      res.writeHead(404, { 'Content-Type': 'text/html' });
      res.end('<h1>404 Not Found</h1>');
      return;
    }

    const ext = path.extname(filePath);
    const contentType = {
      '.html': 'text/html',
      '.xml': 'application/xml',
      '.txt': 'text/plain',
      '.js': 'application/javascript',
      '.css': 'text/css'
    }[ext] || 'text/plain';

    res.writeHead(200, { 'Content-Type': contentType });
    res.end(content);
  });
});

server.listen(PORT, () => {
  console.log(`🌐 ocenkiru.life running on http://localhost:${PORT}`);
});
