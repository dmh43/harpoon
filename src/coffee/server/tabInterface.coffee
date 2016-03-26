getTabs = (dbConn)->
  (operation) ->
    dbConn.query('SELECT * FROM tabs', (err, rows) ->
      if err then throw err
      operation(rows))

writeTab = (dbConn) ->
  (tab) ->
    tab['numFav'] = 0
    dbConn.query 'INSERT INTO tabs SET ?', tab,
      (err, res) -> if err then throw err

exports.getTabs = getTabs
exports.writeTab = writeTab

methodsToCurry = {
  getTabs: getTabs
  writeTab: writeTab
}

methods = {}

module.exports = (dbConn) ->
  for methodName in Object.keys(methodsToCurry)
    methods[methodName] = methodsToCurry[methodName](dbConn)
  return methods
