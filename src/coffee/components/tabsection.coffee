React = require 'react'
{Component} = React
{div, h1} = React.DOM

Tab = React.createFactory require './tab'

class TabSection extends Component
  render: ->
    return div
      ref: (ref) => @tabSection = ref
      className: "tabSection",
      h1 {}, "Tab Viewer"
      Tab
        title: @props.tab.title
        notes: @props.tab.notes

module.exports = TabSection
