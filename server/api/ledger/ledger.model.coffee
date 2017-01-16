'use strict'

mongoose = require 'mongoose'
Float = require('mongoose-float').loadType(mongoose)

Schema = mongoose.Schema

ledgerSchema = new Schema
  user: {
    id: String
    username: String
    name: String
    email: String
  }
  format: { type: String, enum: ['loot', 'contest', 'won', 'gem', 'prize'] }
  status: String
  transaction: [
    {
      action: { type: String, enum: ['plus', 'minus'] }
      from: String
      to: String
      description: String
      amount: Float
      tax: Float
      ref: {
        format: String
        id: String
      }
    }
  ]
  balance: {
    coins: { type: Number, default: 0 }
    diamonds: { type: Number, default: 0 }
    emeralds: { type: Number, default: 0 }
    sapphires: { type: Number, default: 0 }
    rubies: { type: Number, default: 0 }
  }
  details: {
    tracking_number: String
    carrier: String
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
