express = require 'express'
fs = require 'fs'
app = express()
server = app.listen(3000)
io = require('socket.io').listen(server)
path = require 'path'
mysql = require 'mysql'

dbConn =mysql.createConnection({
  host: 'localhost'
  user: 'dany'
  password: '7pqe5fa1'
  database: 'harpoon'})

dbConn.connect((err) ->
  if err
    console.log('DB connection failed')
  else
    console.log('DB connected!'))

getTabs = (operation) ->
  dbConn.query('SELECT * FROM tabs', (err, rows) ->
    if err then throw err
    console.log('Got some tabs from DB')
    operation(rows))

writeTab = (tab) ->
  dbConn.query('INSERT INTO tabs SET ?', tab,
    (err, res) ->
      if err then throw err
      console.log('Last tab ID:', res.insertId))

io.on('connection', (socket) ->
  console.log('Connected!')
  socket.on('get tab', (tabTitle) ->
    getTabs((rows) ->
      socket.emit('here is tab',
        (tab for tab in rows when tab.title == tabTitle)[0])
      console.log('sent a tab')))
  socket.on('get tab names', () ->
      console.log('sending titles')
      getTabs((rows) ->
        console.log(rows)
        socket.emit('here are titles',
          (tab.title for tab in rows))))
  socket.on('tab submission', (tab) ->
    writeTab(tab)
    io.emit('tabs changed')
    console.log('got a new tab!'))
  )

app.use(express.static('./'))

root = exports ? this
root.getTabs = getTabs
root.writeTab = writeTab
