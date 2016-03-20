React = require 'react'
{Component} = React
{div, li, img, span} = React.DOM

coloredStyle = (isColored) ->
  if isColored
    return {filter: 'grayscale(0%)', 'WebkitFilter': 'grayscale(0%)'}
  else
    return {}

class TabListItem extends Component
  render: ->
    return span
      className: "title-holder"
      div
        className: "fav-container"
        style: coloredStyle(@props.isUserFav)
        img
          className: "fav-icon"
          src: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Emblem-favorites.svg/48px-Emblem-favorites.svg.png"
        div className: "fav-count",
          @props.numFav
      li
        className: "menu-item"
        onClick: @props.onItemClick
        @props.title

module.exports = TabListItem
