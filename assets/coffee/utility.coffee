getTitles =
  (socket, callback) =>
    socket.emit 'get tab names'
    socket.on 'here are titles', callback

exports.getTitles = getTitles
