'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ledgerSchema = new Schema
  user_id: String
  transaction: String
  amount: Number
  balance: Number

module.exports = mongoose.model 'ledger', ledgerSchema
