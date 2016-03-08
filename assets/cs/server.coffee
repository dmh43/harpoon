express = require 'express'
fs = require 'fs'
app = express()
#server = require('http').Server(app)
server = app.listen(3000)
io = require('socket.io').listen(server)
path = require 'path'
mysql = require 'mysql'

dbConn =mysql.createConnection({
  host: "localhost"
  user: "dany"
  password: "7pqe5fa1"})

dbConn.connect((err) ->
  if err
    console.log("DB connection failed")
  else
    console.log("DB connected!"))

tabs_path = "/../json/tabs.json"

getTabs = () ->
  return JSON.parse(fs.readFileSync(__dirname + tabs_path)).tabs

tabs = getTabs()

io.on('connection', (socket) ->
  console.log('Connected!')
  fs.watch(__dirname + tabs_path, (e) ->
    console.log('tab list changed!')
    socket.emit('tabs changed'))
  socket.on('get tab', (tabTitle) ->
    socket.emit('here is tab',
      (tab for tab in getTabs() when tab.title == tabTitle)[0])
    console.log('sent a tab'))
  socket.on('get tab names', () ->
    socket.emit('here are titles',
      (tab.title for tab in getTabs()))))

parseTab = (tab) ->
  return tab.title + "\n" + tab.notes

app.use(express.static("./"))
app.listen(8000, -> console.log('Listening bby'))
