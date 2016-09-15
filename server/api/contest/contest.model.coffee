'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ContestSchema = new Schema
  name: String
  program: String
  max_player: Number
  owner: String
  participant: []
  prize: Number
  loot: {
    prize: Number
    category: String
  }

  fee: Number
  public: Boolean

module.exports = mongoose.model 'Contest', ContestSchema
