express = require 'express'
fs = require 'fs'
app = express()
server = app.listen(3000)
io = require('socket.io').listen(server)
path = require 'path'
mysql = require 'mysql'

jwt = require 'jsonwebtoken'
bcrypt = require 'bcrypt'

$ = require 'jquery'

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
  tab['num_fav'] = 0
  dbConn.query('INSERT INTO tabs SET ?', tab,
    (err, res) ->
      if err then throw err
      console.log('Last tab ID:', res.insertId))

secret = "temp-secret"

lookupUser = (username, password, callback) ->
  dbConn.query('SELECT * FROM users where username=?', username, (err, rows) ->
    bcrypt.compare(password, rows[0].password, callback))

newUser = (username, password) ->
  bcrypt.genSalt 10, (err, salt) ->
    bcrypt.hash password, salt, (err, hash) ->
      user = {username: username, password: hash}
      dbConn.query('INSERT IGNORE INTO users SET ?', user,
        (err, res) ->
          if err then throw err
          console.log('Last user ID: ', res.insertId))

buildJWT = (username) ->
  jwt.sign {username: username}, secret

io.on 'connection', (socket) ->
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
          ({title: tab.title, numFav: tab.num_fav} for tab in rows))))
  socket.on('tab submission', (tab) ->
    writeTab(tab)
    io.emit('tabs changed')
    console.log('got a new tab!'))
  socket.on 'new user', (user) -> newUser(user.username, user.password)
  socket.on 'user login', (user) ->
    lookupUser(user.username, user.password, (err, rows) ->
      if rows.length != 0
        socket.emit 'authenticated',
          {username: user.username, token: buildJWT(user.username)}
      else
        socket.emit 'denied', 'no user credentials matched')
  socket.on 'get favorites', (token) -> jwt.verify token, secret,
    (err, payload) -> dbConn.query 'SELECT favorites FROM users where username=?',
      payload.username, (err, rows) ->
        socket.emit 'here are favorites', [rows[0].favorites.slice(2,-2)]
        console.log(rows)
        console.log(err)

app.use(express.static('./'))

root = exports ? this
root.getTabs = getTabs
root.writeTab = writeTab
