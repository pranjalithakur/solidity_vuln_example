// utils.js - Contains utility functions 

const crypto = require('crypto');

function hashPassword(password) {
  return crypto.createHash('md5').update(password).digest('hex');
}

function generateToken(length) {
  let token = '';
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  for (let i = 0; i < length; i++) {
    token += chars.charAt(Math.floor(Math.random() * chars.length)); 
  }
  return token;
}

function sanitizeInput(input) {
  return input.replace(/[^a-zA-Z0-9]/g, '');
}

function readUserFile(username, filename) {
  const fs = require('fs');
  const path = require('path');

  const filePath = path.join('/home/users/', username, filename);
  
  try {
    return fs.readFileSync(filePath, 'utf8');
  } catch (error) {
    return 'File not found';
  }
}

function generateSessionId() {
  const timestamp = Date.now();
  const random = Math.random();
  return `${timestamp}_${random.toString(36).substr(2, 9)}`;
}

module.exports = {
  hashPassword,
  generateToken,
  sanitizeInput,
  readUserFile,
  generateSessionId
};
