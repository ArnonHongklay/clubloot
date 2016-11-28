'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ContestSchema = new Schema
  name: String
  program: String
  owner: String
  prize: Number
  loot: {
    prize: Number
    category: String
  }
  start_time: Date
  end_time: Date
  status: String
  stage: String
  challenge: Number
  max_player: Number
  participant: []
  player: [
    {
      uid: String
      name: String
      score: Number
      q_id: String
      answers: []
    }
  ]
  fee: Number
  public: Boolean
  template_id : String

module.exports = mongoose.model 'Contest', ContestSchema
