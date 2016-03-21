React = require 'react'
{Component} = React
{div, ul, h1} = React.DOM

TabListItem = React.createFactory require './tablistitem'

class TabList extends Component
  render: ->
    filteredTitles = @props.songs.filter (song) =>
      return song.title.toLowerCase().includes @props.searchTerm.toLowerCase()
    tabItems = filteredTitles.map (song) =>
      return TabListItem
        title: song.title
        numFav: song.numFav
        key: song.id
        onFav: @props.onFav(song.id, @props.jwt)
        onItemClick: @props.onTitleClick(song.id)
        isUserFav: @props.userFavs.includes(song.id)
    return div className: "tabList",
      ul id: "tabs", tabItems

module.exports = TabList
