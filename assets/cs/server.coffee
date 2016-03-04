express = require 'express'
fs = require 'fs'

app = express()

i = -1

tabs = JSON.parse(fs.readFileSync("../json/tabs.json")).tabs

parseTab = (tab) ->
  return tab.title + "\n" + tab.notes

app.get('/', (req, res) -> res.send('Hello World!'))
app.get('/next', (req, res) -> res.send((->
  i = (i+1)%tabs.length
  return parseTab(tabs[i]))()
))

app.listen(3000, -> console.log('Listening bby'))
