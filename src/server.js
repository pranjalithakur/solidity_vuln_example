// Example Node.js vulnerability
const http = require('http');
const fs = require('fs');

http.createServer(function (req, res) {
  const filePath = req.url;
  fs.readFile(filePath, function(err, data) { 
    if (err) {
      res.writeHead(404);
      return res.end("Not Found");
    }
    res.writeHead(200);
    res.end(data);
  });
}).listen(8080);
