
'use strict'

_ = require 'lodash'
Program = require './program.model'

# Get list of programs
exports.index = (req, res) ->
  Program.find (err, programs) ->
    return handleError(res, err)  if err
    res.status(200).json programs

# Get a single program
exports.show = (req, res) ->
  Program.findById req.params.id, (err, program) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless program
    res.json program

# Creates a new program in the DB.
exports.create = (req, res) ->
  Program.create req.body, (err, program) ->
    return handleError(res, err)  if err
    res.status(201).json program

# Updates an existing program in the DB.
exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Program.findById req.params.id, (err, program) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless program
    updated = _.merge(program, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.status(200).json program

# Deletes a program from the DB.
exports.destroy = (req, res) ->
  Program.findById req.params.id, (err, program) ->
    return handleError(res, err)  if err
    return res.status(404).end()  unless program
    program.remove (err) ->
      return handleError(res, err)  if err
      res.status(204).end()

handleError = (res, err) ->
  res.status(500).json err
