React = require 'react'
ReactDOM = require 'react-dom'
Sidebar = require 'react-sidebar'
Sidebar = Sidebar.default
Menu = (require 'react-burger-menu').slide

burgerStyles = {
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
    width: '24px'
  },
  bmCross: {
    background: '#bdc3c7'
  },
  bmMenu: {
    background: '#373a47',
    padding: '0 1.5em 0',
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
}

tabSecStyle = {
  position: "relative"
  "margin-left": "100px"
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
    style: tabSecStyle},
    React.createElement('h1', {}, "Tab Viewer"),
    React.createElement(Tab, {title: "This is my tab!", notes: "1 2 3"})))
  }
)

TabList = React.createClass({
  displayName: 'TabList',
  render: -> return (React.createElement('div',
    {className: "tabList"},
    React.createElement('h1', {}, "All Tabs"),
    React.createElement('ul', {id: "tabs"},
      React.createElement('li', {}, "first Tab name!"))))})

Page = React.createClass({
  displayName: 'Page',
  showSettings: (e) -> e.preventDefault(),
  render: ->
    return (React.createElement('div', {className: "page"},
      React.createElement(Menu, {
        className: "menu",
        styles: burgerStyles},
        React.createElement(TabList)),
      React.createElement(TabSection)
    ))
  })

ReactDOM.render(React.createElement(Page, null),
  document.getElementById('content'))
