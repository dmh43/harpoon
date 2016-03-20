React = require 'react'
ReactDOM = require 'react-dom'
Menu = React.createFactory (require 'react-burger-menu').slide
tablist = React.createFactory require './components/tablist'
toolbar = React.createFactory require './components/toolbar'
view = React.createFactory require './components/view'

{div, label, input, button, textarea} = React.DOM

io = require 'socket.io-client'
socket = io()

getTitles = require('./utility').getTitles

Page = React.createClass
  displayName: 'Page'

  showSettings: (e) -> e.preventDefault()

  getInitialState: ->
    return {
      tab:
        title:'No Tab Selected'
        notes: 'Select a tab from the side bar to the left'
      titles: [{title: 'DEAD', numFav: 0}, {title: 'BEEF', numFav: 0}]
      searchTerm: ''
      notesEntry: ''
      titleEntry: ''
      userFavs: []
      userJWT: null
      username: null
      view: 'tabview'
    }

  componentDidMount: () ->
    getTitles(socket, (titles) => @setState(titles: titles))
    socket.on('tabs changed', => getTitles(socket, (titles) => @setState(titles: titles)))
    socket.on 'authenticated', (message) =>
      @setState
        userJWT: message.token
        username: message.username
      socket.emit('get favorites', message.token)
    socket.on 'here are favorites', (favs) =>
      @setState(userFavs: favs)
      console.log(favs)

  searchUpdated: (e) -> @setState(searchTerm: e.target.value)

  setTab: (tab) -> @setState(tab: tab)

  setTitles: (titles) -> @setState(titles: titles)

  onTitleClick: (title) ->
    return =>
      @Sidebar.setState(isOpen: false)
      socket.emit('get tab', title)
      socket.on('here is tab', (tab) =>
        console.log(tab)
        @setState(tab:tab))

  setView: (view) -> @setState(view: view)

  loginUser: (user) ->
    socket.emit 'user login', user

  logoffUser: -> @setState
    userFavs: []
    username: ''

  render: ->
    div
      className: 'page',
      toolbar
        className: 'toolbar'
        username: @state.username
        toCreateUser: => @setView('signupView')
        socket: socket
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
            titles: @state.titles
            searchTerm: @state.searchTerm
            onTitleClick: @onTitleClick
            userFavs: @state.userFavs
      view
        className: 'view'
        view: @state.view
        socket: socket
        tab : @state.tab
        setTab: @setTab
        setTitles: @setTitles
        loginUser: @loginUser

ReactDOM.render(React.createElement(Page),
  document.getElementById('content'))
