getSongs =
  (socket, callback) =>
    socket.emit 'get tab names'
    socket.on 'here are songs', callback

exports.getSongs = getSongs
