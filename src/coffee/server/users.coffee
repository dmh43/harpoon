bcrypt = require 'bcrypt'
jwt = require 'jsonwebtoken'

secret = "temp-secret"

lookupUser = (dbConn) ->
  (username, password, callback) ->
    dbConn.query('SELECT * FROM users where username=?', username, (err, rows) ->
      if err or rows.length == 0
        callback false
      else
        bcrypt.compare(password, rows[0].password, callback))

newUser = (dbConn) ->
  (username, password, callback) ->
    bcrypt.genSalt 10, (err, salt) ->
      bcrypt.hash password, salt, (err, hash) ->
        user = {username: username, password: hash, favorites: '[]'}
        dbConn.query 'INSERT INTO users SET ?', user,
          (err, res) ->
            if err then callback 'user creation failed'
            callback 'user created'

buildJWT = (username) -> jwt.sign username: username, secret

toggleFav = (dbConn) ->
  (username, tabID) ->
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

methodsToCurry = {
  lookupUser: lookupUser
  newUser: newUser
  toggleFav: toggleFav
}

methods = buildJWT: buildJWT

module.exports = (dbConn) ->
  for methodName in Object.keys(methodsToCurry)
    methods[methodName] = methodsToCurry[methodName](dbConn)
  return methods
