express = require 'express'
fs = require 'fs'
app = express()
server = app.listen(3000)
io = require('socket.io').listen(server)
path = require 'path'
mysql = require 'mysql'

dbConn =mysql.createConnection({
  host: "localhost"
  user: "dany"
  password: "7pqe5fa1"
  database: "harpoon"})

dbConn.connect((err) ->
  if err
    console.log("DB connection failed")
  else
    console.log("DB connected!"))

getTabs = (operation) ->
  dbConn.query('SELECT * FROM tabs', (err, rows) ->
    if err then throw err
    console.log('Got some tabs from DB')
    operation(rows))

io.on('connection', (socket) ->
  console.log('Connected!')
  socket.on('tab submission', (e) ->
    console.log('tab list changed!')
    socket.emit('tabs changed'))
  getTabs((rows) ->
    socket.on('get tab', (tabTitle) ->
      socket.emit('here is tab',
        (tab for tab in rows when tab.title == tabTitle)[0])
    console.log('sent a tab')))
  getTabs((rows) ->
    socket.on('get tab names', () ->
      socket.emit('here are titles',
        (tab.title for tab in rows)))))

app.use(express.static("./"))
app.listen(8000, -> console.log('Listening bby'))
