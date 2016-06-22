###*
Main application file
###
'use strict'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

express = require 'express'
mongoose = require 'mongoose'
config = require './config/environment'

# Connect to database
mongoose.connect config.mongo.uri, config.mongo.options

mongoose.connection.on 'error', (err) ->
  console.error "MongoDB connection error: #{err}"
  process.exit -1

# Populate DB with sample data
require './config/seed'  if config.seedDB

# Setup server
app = express()
server = require('http').createServer app
socketio = require('socket.io')(server,
  serveClient: (if (config.env is 'production') then false else true)
  path: '/socket.io-client'
)
require('./config/socketio') socketio
require('./config/express') app
require('./routes') app

# Start server
server.listen config.port, config.ip, ->
  console.log 'Express server listening on %d, in %s mode', config.port, app.get('env')

# Expose app
exports = module.exports = app
