'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ContestSchema = new Schema
  name: String
  program: String
  player: Number
  prize: String
  fee: Number
  public: Boolean

module.exports = mongoose.model 'Contest', ContestSchema
