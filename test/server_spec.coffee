mysql = require 'mysql'
chai = require 'chai'
should = chai.should()
getTabs = require('../assets/cs/server').getTabs
writeTab = require('../assets/cs/server').writeTab

blues_tab = {"title" : "Blues scale", "notes" : "-2 -3' 4 -4' -4 -5 6"}

describe 'db interface', ->
  before ->
    dbConn = mysql.createConnection
      host: "localhost"
      user: "tester"
      password: "1234"
      database: "test_db"
    dbConn.connect((err) -> throw err)

  describe '#getTabs()', ->
    it 'should return nothing when no tabs exist', (done) ->
      getTabs((rows) -> rows.should.be.empty)
      done()
    it 'should return all tabs in the db', (done) ->
      writeTab(blues_tab)
      getTabs((rows) ->
        console.log(rows)
        rows.should.equal(blues_tab))
      done()
