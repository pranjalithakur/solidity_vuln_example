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

module.exports = {
  hashPassword,
  generateToken,
  sanitizeInput
};
