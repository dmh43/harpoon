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
    operation(rows))

writeTab = (tab) ->
  tab['numFav'] = 0
  dbConn.query 'INSERT INTO tabs SET ?', tab,
    (err, res) -> if err then throw err

secret = "temp-secret"

lookupUser = (username, password, callback) ->
  dbConn.query('SELECT * FROM users where username=?', username, (err, rows) ->
    if err or rows.length == 0
      callback false
    else
      bcrypt.compare(password, rows[0].password, callback))

newUser = (username, password, callback) ->
  bcrypt.genSalt 10, (err, salt) ->
    bcrypt.hash password, salt, (err, hash) ->
      user = {username: username, password: hash, favorites: '[]'}
      dbConn.query 'INSERT INTO users SET ?', user,
        (err, res) ->
          if err then callback 'user creation failed'
          callback 'user created'

buildJWT = (username) ->
  jwt.sign {username: username}, secret

toggleFav = (username, tabID) ->
  dbConn.query 'SELECT favorites FROM users where username=?', username,
    (err, rows) ->
      favs = JSON.parse(rows[0].favorites)
      dbConn.query 'SELECT numFav FROM tabs where id=?', tabID,
        ((favs) ->
          return (err, rows_id) ->
            numFav = parseInt rows_id[0].numFav
            if tabID in favs
              numFav = numFav+1
            else
              numFav = numFav-1
            dbConn.query('UPDATE tabs SET numFav=? where id=?', [numFav, tabID]))(favs)
      if tabID in favs
        favs.splice(favs.indexOf(tabID), 1)
      else
        favs.push(tabID)
      dbConn.query('UPDATE users SET favorites=JSON_ARRAY(?) where username=?', [favs, username])
      io.emit('favs changed')
      io.emit('numFav changed', tabID)

io.on 'connection', (socket) ->

  socket.on 'get tab', (tabID) ->
    getTabs (rows) ->
      socket.emit 'here is tab',
        (tab for tab in rows when tab.id == tabID)[0]

  socket.on 'toggle fav', (data) ->
    jwt.verify data.jwt, secret, (err, payload) ->
      username = payload.username
      tabID = data.id
      toggleFav(username, tabID)

  socket.on('get tab names', () ->
      getTabs((rows) ->
        socket.emit('here are songs', rows)))

  socket.on 'tab submission', (tab) ->
    writeTab(tab)
    io.emit('tabs changed')

  socket.on 'new user', (user) ->
    newUser(user.username, user.password, (event) -> socket.emit event)

  socket.on 'user login', (user) ->
    lookupUser(user.username, user.password, (isMatch) ->
      if isMatch
        socket.emit 'authenticated',
          {username: user.username, token: buildJWT(user.username)}
      else
        socket.emit 'login failed')

  socket.on 'get favorites', (token) -> jwt.verify token, secret,
    (err, payload) -> dbConn.query 'SELECT favorites FROM users where username=?',
      payload.username, (err, rows) ->
        socket.emit 'here are favorites', JSON.parse rows[0].favorites

  socket.on 'get numFav', (tabID) ->
    dbConn.query 'SELECT numFav FROM tabs where id=?', tabID,
      (err, rows) -> socket.emit 'here is numFav',
          {id: tabID, numFav: parseInt rows[0].numFav}

app.use express.static('./')

root = exports ? this
root.getTabs = getTabs
root.writeTab = writeTab
