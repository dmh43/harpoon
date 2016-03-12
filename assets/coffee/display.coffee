React = require 'react'
ReactDOM = require 'react-dom'
Menu = React.createFactory (require 'react-burger-menu').slide
tabsection = React.createFactory require './components/tabsection'
tablist = React.createFactory require './components/tablist'
toolbar = React.createFactory require './components/toolbar'
tabinput = React.createFactory require './components/tabinput'

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
      titles: ['DEAD', 'BEEF']
      searchTerm: ''
      notesEntry: ''
      titleEntry: ''
      userData: {isLoggedIn: false}
    }

  componentDidMount: () ->
    getTitles(socket, (titles) => @setState(titles: titles))
    socket.on('tabs changed', getTitles(socket, (titles) => @setState(titles: titles)))

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

  render: ->
    div
      className: 'page',
      toolbar
        className: 'toolbar'
        userData: @state.userData
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
      div
        className: 'view'
        tabsection
          className: 'tabSection'
          tab: @state.tab
        tabinput
          className: 'tabInput'
          socket: socket
          setTab: @setTab
          setTitles: @setTitles

ReactDOM.render(React.createElement(Page),
  document.getElementById('content'))
