'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

TaxSchema = new Schema
  type: String
  coin: Number
  user_id: Number
  created_at: Date
  contest_id: Number

module.exports = mongoose.model 'Tax', TaxSchema
