'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

GemcSchema = new Schema
  diamond:  { rate: Number },
  emerald:  { rate: Number },
  sapphire: { rate: Number },
  ruby:     { rate: Number }

module.exports = mongoose.model 'Gemc', GemcSchema
