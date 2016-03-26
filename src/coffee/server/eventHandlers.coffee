getTabHandler = (tabID) ->
  getTabs (rows) ->
    socket.emit 'here is tab', (tab for tab in rows when tab.id == tabID)[0]

events = {
  'get tab': }
