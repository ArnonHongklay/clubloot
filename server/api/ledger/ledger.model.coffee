'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

ledgerSchema = new Schema
  user_id: String

module.exports = mongoose.model 'ledger', ledgerSchema
