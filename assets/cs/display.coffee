React = require 'react'
ReactDOM = require 'react-dom'
Menu = (require 'react-burger-menu').slide
$ = require 'jquery'
io = require 'socket.io-client'
socket = io()

Styles = {
  burger: {
    bmBurgerButton: {
      position: 'fixed',
      width: '36px',
      height: '30px',
      left: '80px',
      top: '36px'
    },
    bmBurgerBars: {
      background: '#373a47'
    },
    bmCrossButton: {
      height: '24px',
      width: '24px',
    },
    bmCross: {
      background: '#bdc3c7'
    },
    bmMenu: {
      background: '#373a47',
      padding: '0em 1.5em 0',
      fontSize: '1.15em'
    },
    bmMorphShape: {
      fill: '#373a47'
    },
    bmItemList: {
      color: '#b8b7ad',
      padding: '0.8em'
    },
    bmOverlay: {
      background: 'rgba(0, 0, 0, 0.3)'
    }
  },
  tabSec: {
    position: "relative"
    "marginLeft": "100px"
  }
}

Tab = React.createClass({
  displayName: 'Tab',
  render: -> return (React.createElement('div',
    {className: "tab"},
    React.createElement('h2', {}, @props.title),
    React.createElement('div', {className: "notes"}, @props.notes)))})

TabSection = React.createClass({
  displayName: 'TabSection',
  render: -> return (React.createElement('div', {
    className: "tabSection",
    style: Styles.tabSec},
    React.createElement('h1', {}, "Tab Viewer"),
    React.createElement(Tab, {title: @props.tab.title, notes: @props.tab.notes})))
  }
)

TabListItem = React.createClass({
  displayName: "TabListItem"
  render: ->
    React.createElement('li', {
      className: "menu-item"
      onClick: =>
        socket.emit('get tab', @props.title)
        socket.on('here is tab', (tab) ->
          console.log(tab))
    },
    @props.title)})

TabList = React.createClass({
  displayName: 'TabList',
  render: ->
    tabItems = @props.titles.map((title) ->
      return React.createElement(TabListItem, {title: title}))
    return (React.createElement('div',
      {className: "tabList"},
      React.createElement('h1', {}, "All Tabs"),
      React.createElement('ul', {id: "tabs"}, tabItems)))})

Page = React.createClass({
  displayName: 'Page',
  showSettings: (e) -> e.preventDefault(),
  getInitialState: ->
    return {tab: {title:'khiri', notes: '12'}, titles: ["khiri", "ballout"]}
  componentDidMount: () ->
    that = this
    socket.emit('get tab names')
    socket.on('here are titles', (titles) ->
      that.setState({titles: titles}))
  render: ->
    return (React.createElement('div', {
      className: "page"},
      React.createElement(Menu, {
        className: "menu",
        styles: Styles.burger
        },
        React.createElement(TabList, {titles: @state.titles})),
      React.createElement(TabSection, {tab: @state.tab})
    ))
  })

ReactDOM.render(React.createElement(Page),
  document.getElementById('content'))
