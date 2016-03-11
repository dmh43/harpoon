React = require 'react'
ReactDOM = require 'react-dom'
Menu = React.createFactory (require 'react-burger-menu').slide
Form = React.createFactory (require 'react-form-controlled').default
tabsection = React.createFactory require './components/tabsection'
tablist = React.createFactory require './components/tablist'

io = require 'socket.io-client'
socket = io()

{div, label, input, button, textarea} = React.DOM

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
    }

  getTitles: ->
    that = this
    socket.emit('get tab names')
    socket.on('here are titles', (titles) ->
      that.setState({titles: titles}))
    console.log(that.state.titles)

  componentDidMount: () ->
    @getTitles()
    socket.on('tabs changed', => @getTitles())

  handleFormChange: (state) -> @setState(state)

  handleFormSubmit: (state) ->
    tab = {title: state.titleEntry, notes: state.notesEntry}
    console.log(tab)
    socket.emit('tab submission', tab)
    @setState({
      titleEntry: ''
      notesEntry: ''
      tab: tab})
    @getTitles()

  searchUpdated: (e) -> @setState(searchTerm: e.target.value)

  render: ->
    that = this
    div
      className: 'page',
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
            onTitleClick: (title) =>
              return =>
                @Sidebar.setState(isOpen: false)
                socket.emit('get tab', title)
                socket.on('here is tab', (tab) =>
                  console.log(tab)
                  @setState(tab:tab))
      tabsection
        className: 'tabSection'
        tab: @state.tab
      Form
        className: 'form'
        value: @state
        onChange: that.handleFormChange
        onSubmit: that.handleFormSubmit,
        div {},
          label {},
            input
              type: 'text'
              name: 'titleEntry'
              placeholder: 'Tab Title'
        div {},
          label {},
            textarea
              type: 'text'
              name: 'notesEntry'
              placeholder: 'Enter a tab!'
        button
          type: 'submit'
          'Submit'

ReactDOM.render(React.createElement(Page),
  document.getElementById('content'))
