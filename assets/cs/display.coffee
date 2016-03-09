React = require 'react'
ReactDOM = require 'react-dom'
Menu = React.createFactory (require 'react-burger-menu').slide
Form = React.createFactory (require 'react-form-controlled').default
io = require 'socket.io-client'
socket = io()
{tab, tabsection, tablist, tablistitem} = require('./reactClasses.coffee').creators
Styles = require('./reactClasses.coffee').Styles

Page = React.createClass({
  displayName: 'Page'
  showSettings: (e) -> e.preventDefault()
  getInitialState: ->
    return {
      tab:
        title:'No Tab Selected'
        notes: 'Select a tab from the side bar to the left'
      titles: ["DEAD", "BEEF"]
      menuOpen: false
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
    socket.emit("tab submission", tab)
    @setState({
      titleEntry: ""
      notesEntry: ""
      tab: tab})
    @getTitles()

  render: ->
    {div, label, input, button} = React.DOM
    that = this
    div
      className: 'page',
      Menu
        className: "menu",
        styles: Styles.burger
        ref: (ref) => @Sidebar = ref,
        tablist
          titles: @state.titles
          onTitleClick: (title) =>
            return =>
              @Sidebar.setState(isOpen: false)
              socket.emit('get tab', title)
              socket.on('here is tab', (tab) =>
                console.log(tab)
                @setState(tab:tab))
      tabsection
        tab: @state.tab
      Form
        style: Styles.form
        value: @state
        onChange: that.handleFormChange
        onSubmit: that.handleFormSubmit,
        div {},
          label {},
            input
              style: Styles.titleEntry
              type: 'text'
              name: "titleEntry"
              placeholder: "Tab Title"
        div {},
          label {},
            input
              style: Styles.notesEntry
              type: 'text'
              name: "notesEntry"
              placeholder: "Enter a tab!"
        button
          type: 'submit'
          style:
            position: 'relative'
            "marginLeft": "100px"
          'Submit'
  })

ReactDOM.render(React.createElement(Page),
  document.getElementById('content'))
