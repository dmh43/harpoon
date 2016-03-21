React = require 'react'
ReactDOM = require 'react-dom'
Menu = React.createFactory (require 'react-burger-menu').slide
tablist = React.createFactory require './components/tablist'
toolbar = React.createFactory require './components/toolbar'
view = React.createFactory require './components/view'

{div, label, input, button, textarea} = React.DOM

io = require 'socket.io-client'
socket = io()

getSongs = require('./utility').getSongs

Page = React.createClass
  displayName: 'Page'

  showSettings: (e) -> e.preventDefault()

  getInitialState: ->
    return {
      tab:
        title:'No Tab Selected'
        notes: 'Select a tab from the side bar to the left'
      songs: [{title: 'DEAD', numFav: 0, id:0}, {title: 'BEEF', numFav: 0, id:1}]
      searchTerm: ''
      notesEntry: ''
      titleEntry: ''
      userFavs: []
      userJWT: localStorage.userJWT
      username: localStorage.username
      view: 'tabview'
    }

  componentDidMount: () ->
    getSongs(socket, (songs) => @setState(songs: songs))

    socket.on('here is tab', (tab) =>
      @setState(tab:tab))

    socket.on('tabs changed', =>
      getSongs(socket, (songs) => @setState(songs: songs)))

    socket.on 'authenticated', (message) =>
      @setState
        userJWT: message.token
        username: message.username
      localStorage.setItem('userJWT', message.token)
      localStorage.setItem('username', message.username)
      socket.emit('get favorites', message.token)

    socket.on 'here are favorites', (favs) =>
      @setState(userFavs: favs)

    socket.on 'favs changed', => socket.emit 'get favorites', @state.userJWT

    socket.on 'numFav changed', (tabID) =>
      socket.emit 'get numFav', tabID

    socket.on 'here is numFav', (data) =>
      @setState(songs:
        for song in @state.songs
          if song.id != data.id
            song
          else
            {title: song.title, numFav: data.numFav, id: data.id})

  searchUpdated: (e) -> @setState(searchTerm: e.target.value)

  setTab: (tab) -> @setState(tab: tab)

  setSongs: (songs) -> @setState(songs: songs)

  onTitleClick: (id) ->
    return =>
      @Sidebar.setState(isOpen: false)
      socket.emit('get tab', id)

  toggleFav: (id, jwt) ->
    return =>
      if jwt
        socket.emit('toggle fav', {id:id, jwt: @state.userJWT})

  setView: (view) -> @setState(view: view)

  loginUser: (user) ->
    socket.emit 'user login', user

  logoffUser: ->
    localStorage.removeItem 'userJWT'
    localStorage.removeItem 'username'
    @setState
      userFavs: []
      username: ''
      userJWT: {}

  render: ->
    div
      className: 'page',
      toolbar
        className: 'toolbar'
        username: @state.username
        toCreateUser: => @setView('signupView')
        loginUser: @loginUser
        logoffUser: @logoffUser
      Menu
        className: 'menu',
        ref: (ref) => @Sidebar = ref,
        div {},
          input
            className: 'search-input'
            onChange: @searchUpdated
          tablist
            songs: @state.songs
            searchTerm: @state.searchTerm
            onTitleClick: @onTitleClick
            onFav: @toggleFav
            userFavs: @state.userFavs
            jwt: @state.username
      view
        className: 'view'
        view: @state.view
        socket: socket
        tab : @state.tab
        setTab: @setTab
        setSongs: @setSongs
        loginUser: @loginUser

ReactDOM.render(React.createElement(Page),
  document.getElementById('content'))
