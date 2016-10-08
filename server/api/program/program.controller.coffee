
'use strict'

_ = require 'lodash'
Program = require './program.model'

fs = require 'fs'
im = require 'imagemagick'

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
    console.log program
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

exports.upload = (req, res) ->
  fs.readFile req.files.file.path, (err, data) ->
    imageName = req.files.file.name
    console.log imageName
    #/ If there's an error
    if imageName
      imagePath = __dirname.replace('/.server/api/program', '') + '/uploads/fullsize/' + imageName
      console.log imagePath
      fs.writeFile imagePath, data, (err) ->
        res.status(200).json imagePath
    else
      res.status(404).json imageName

handleError = (res, err) ->
  res.status(500).json err
