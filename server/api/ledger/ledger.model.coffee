'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ledgerSchema = new Schema
  action: String # 'plus', 'minus'
  user: {
    id: String
    name: String
    email: String
  }
  transaction: {
    format: String # 'loot', 'play game', 'gem', 'prize'
    from: String
    to: String
    amount: Number
    tax: Number
  }
  balance: {
    diamonds: { type: Number, default: 0 }
    emeralds: { type: Number, default: 0 }
    sapphires: { type: Number, default: 0 }
    rubies: { type: Number, default: 0 }
    coins: { type: Number, default: 0 }
  }
  created_at: Date
  updated_at: Date

ledgerSchema.pre 'save', (next) ->
  now = new Date
  @updated_at = now
  if !@created_at
    @created_at = now
  next()

module.exports = mongoose.model 'ledger', ledgerSchema
