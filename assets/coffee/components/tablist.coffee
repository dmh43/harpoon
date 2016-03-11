React = require 'react'
{Component} = React
{div, ul, h1} = React.DOM

TabListItem = React.createFactory require './tablistitem'

class TabList extends Component
  render: ->
    filteredTitles = @props.titles.filter (title) =>
      return title.toLowerCase().includes @props.searchTerm.toLowerCase()
    tabItems = filteredTitles.map (title) =>
      return TabListItem
        title: title
        key: title
        onClick: @props.onTitleClick(title)
    return div className: "tabList",
      h1 {}, "All Tabs"
      ul id: "tabs", tabItems

module.exports = TabList
