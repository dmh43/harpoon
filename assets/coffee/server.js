(function() {
  var app, dbConn, express, fs, getTabs, io, mysql, path, root, server, writeTab;

  express = require('express');

  fs = require('fs');

  app = express();

  server = app.listen(3000);

  io = require('socket.io').listen(server);

  path = require('path');

  mysql = require('mysql');

  dbConn = mysql.createConnection({
    host: 'localhost',
    user: 'dany',
    password: '7pqe5fa1',
    database: 'harpoon'
  });

  dbConn.connect(function(err) {
    if (err) {
      return console.log('DB connection failed');
    } else {
      return console.log('DB connected!');
    }
  });

  getTabs = function(operation) {
    return dbConn.query('SELECT * FROM tabs', function(err, rows) {
      if (err) {
        throw err;
      }
      console.log('Got some tabs from DB');
      return operation(rows);
    });
  };

  writeTab = function(tab) {
    return dbConn.query('INSERT INTO tabs SET ?', tab, function(err, res) {
      if (err) {
        throw err;
      }
      return console.log('Last tab ID:', res.insertId);
    });
  };

  io.on('connection', function(socket) {
    console.log('Connected!');
    socket.on('get tab', function(tabTitle) {
      return getTabs(function(rows) {
        var tab;
        socket.emit('here is tab', ((function() {
          var i, len, results;
          results = [];
          for (i = 0, len = rows.length; i < len; i++) {
            tab = rows[i];
            if (tab.title === tabTitle) {
              results.push(tab);
            }
          }
          return results;
        })())[0]);
        return console.log('sent a tab');
      });
    });
    socket.on('get tab names', function() {
      console.log('sending titles');
      return getTabs(function(rows) {
        var tab;
        console.log(rows);
        return socket.emit('here are titles', (function() {
          var i, len, results;
          results = [];
          for (i = 0, len = rows.length; i < len; i++) {
            tab = rows[i];
            results.push(tab.title);
          }
          return results;
        })());
      });
    });
    return socket.on('tab submission', function(tab) {
      writeTab(tab);
      io.emit('tabs changed');
      return console.log('got a new tab!');
    });
  });

  app.use(express["static"]('./'));

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.getTabs = getTabs;

  root.writeTab = writeTab;

}).call(this);
