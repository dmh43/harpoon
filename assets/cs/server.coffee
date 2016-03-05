express = require 'express'
fs = require 'fs'
app = express()
#server = require('http').Server(app)
server = app.listen(3000)
io = require('socket.io').listen(server)
path = require 'path'

tabs = JSON.parse(fs.readFileSync(__dirname+ "/../json/tabs.json")).tabs

io.on('connection', (socket) ->
  console.log('Connected!')
  socket.on('get tab', (tabTitle) ->
    socket.emit('here is tab',
      (tab for tab in tabs when tab.title == tabTitle)[0])
    console.log('sent a tab'))
  socket.on('get tab names', () ->
    socket.emit('here are titles',
      (tab.title for tab in tabs))))

parseTab = (tab) ->
  return tab.title + "\n" + tab.notes

app.use(express.static("./"))
app.listen(8000, -> console.log('Listening bby'))
