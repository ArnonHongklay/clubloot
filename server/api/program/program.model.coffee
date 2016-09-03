'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ProgramSchema = new Schema
  name: String
  category: String
  image: String
  active: Boolean

module.exports = mongoose.model 'Program', ProgramSchema
