'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

TemplateSchema = new Schema
  name: String
  info: String
  active: Boolean

module.exports = mongoose.model 'Template', TemplateSchema
