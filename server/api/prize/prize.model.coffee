'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

PrizeSchema = new Schema
  name: String
  info: String
  active: Boolean

module.exports = mongoose.model 'Prize', PrizeSchema
