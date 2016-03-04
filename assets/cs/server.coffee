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

    socket.emit('here is tab', tabs[0])
    console.log('sent a tab')))

parseTab = (tab) ->
  return tab.title + "\n" + tab.notes

app.use(express.static("./"))
app.listen(8000, -> console.log('Listening bby'))
