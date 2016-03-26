React = require 'react'
{Component} = React
{div, h2} = React.DOM

class Tab extends Component
  render: ->
    return div
      className: "tab",
      h2 {}, @props.title
      div className: "notes", @props.notes

module.exports = Tab
