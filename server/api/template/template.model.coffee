'use strict'

mongoose = require 'mongoose'
Schema = mongoose.Schema

TemplateSchema = new Schema
  # name: String
  number_answers: Number
  number_questions: Number
  program: String
  program_image: String
  start_time: Date
  end_time: Date
  active:
    type: Boolean
    default: true


  # new template
  name: String
  program_id: String
  questions: [
    {
      is_correct: Number
      answers: [
        { name: String }
      ]
    }
  ]

module.exports = mongoose.model 'Template', TemplateSchema
