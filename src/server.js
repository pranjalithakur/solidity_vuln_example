// Example Node.js vulnerability
const http = require('http');
const fs = require('fs');
const path = require('path');
// Define a safe public directory for serving files
const PUBLIC_DIR = path.join(__dirname, 'public');
http.createServer(function (req, res) {
  // Parse the URL to get the pathname, removing query strings
  const url = new URL(req.url, `http://${req.headers.host}`);
  const requestedPath = url.pathname;
  
  // Remove leading slash and decode URI components
  const sanitizedPath = decodeURIComponent(requestedPath.replace(/^\/+/, ''));
  
  // Resolve the absolute path and ensure it's within the public directory
  const filePath = path.resolve(PUBLIC_DIR, sanitizedPath);
  
  // Security check: ensure the resolved path is still within PUBLIC_DIR
  if (!filePath.startsWith(path.resolve(PUBLIC_DIR))) {
    res.writeHead(403);
    return res.end("Forbidden: Access denied");
  }
  
  fs.readFile(filePath, function(err, data) {
    if (err) {
      res.writeHead(404);
      return res.end("Not Found");
    }
    res.writeHead(200);
    res.end(data);
  });
}).listen(8080);
