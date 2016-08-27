'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

TemplateSchema = new Schema
  name: String
  description: String
  info: String
  questions:
    question:
      type: String
  start_date: Date
  end_date: Date
  active: Boolean

module.exports = mongoose.model 'Template', TemplateSchema
