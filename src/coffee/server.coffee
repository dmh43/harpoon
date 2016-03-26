express = require 'express'
app = express()
server = app.listen(3000)
io = require('socket.io').listen(server)
mysql = require 'mysql'

dbConn = mysql.createConnection({
  host: 'localhost'
  user: 'dany'
  password: '7pqe5fa1'
  database: 'harpoon'})

dbConn.connect((err) ->
  if err
    console.log('DB connection failed')
  else
    console.log('DB connected!'))

{getTabs, writeTab} = require('./server/tabInterface') dbConn
{lookupUser, newUser, buildJWT, toggleFav} = require('./server/users') dbConn

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
