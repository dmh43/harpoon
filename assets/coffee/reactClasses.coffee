React = require 'react'
ReactDOM = require 'react-dom'
$ = require 'jquery'

root = exports ? this

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
    position: 'relative'
    'marginLeft': '100px'
  }
  titleEntry: {
    position: 'relative'
    'marginLeft': '100px'
    'marginTop': '5rem'
  }
  notesEntry: {
    position: 'relative'
    'marginLeft': '100px'
    'marginTop': '0.5rem'
    'marginBottom': '0.5rem'
    'width': '300px'
    'height': '100px'
  }
  form: {
    position: 'relative'
    'marginLeft': '100px'
  }
}

Tab = React.createClass({
  displayName: 'Tab',
  render: -> return (React.createElement('div',
    {className: 'tab'},
    React.createElement('h2', {}, @props.title),
    React.createElement('div', {className: 'notes'}, @props.notes)))})

TabSection = React.createClass({
  displayName: 'TabSection',
  render: -> return (React.createElement('div', {
    className: 'tabSection',
    style: Styles.tabSec},
    React.createElement('h1', {}, 'Tab Viewer'),
    React.createElement(Tab, {title: @props.tab.title, notes: @props.tab.notes})))
  }
)

TabListItem = React.createClass({
  displayName: 'TabListItem'
  render: ->
    React.createElement('li', {
      className: 'menu-item'
      onClick: @props.onClick
    },
    @props.title)})

TabList = React.createClass
  displayName: 'TabList',
  render: ->
    filteredTitles = @props.titles.filter((title) =>
      return title.toLowerCase().includes(@props.searchTerm.toLowerCase()))
    tabItems = filteredTitles.map((title) =>
      return React.createElement(TabListItem, {
        title: title
        key: title
        onClick: @props.onTitleClick(title)}))
    return (React.createElement('div',
      {className: 'tabList'},
      React.createElement('h1', {}, 'All Tabs'),
      React.createElement('ul', {id: 'tabs'}, tabItems)))

creators = {
  tab: React.createFactory(Tab)
  tabsection: React.createFactory(TabSection)
  tablist: React.createFactory(TabList)
  tablistitem: React.createFactory(TabListItem)
}

root.Styles = Styles
root.creators = creators
