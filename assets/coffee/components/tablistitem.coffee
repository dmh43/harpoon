React = require 'react'
{Component} = React
{div, li} = React.DOM

class TabListItem extends Component
  render: ->
    return li
      className: "menu-item"
      onClick: @props.onClick,
      @props.title

module.exports = TabListItem
