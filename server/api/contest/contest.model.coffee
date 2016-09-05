'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ContestSchema = new Schema
  name: String
  description: String
  info: String
  active: Boolean

module.exports = mongoose.model 'Contest', ContestSchema
