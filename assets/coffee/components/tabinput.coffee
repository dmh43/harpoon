React = require 'react'
{Component} = React
{div, label, input, button, textarea} = React.DOM

Form = React.createFactory (require 'react-form-controlled').default

getTitles = require('../utility').getTitles

class TabInput extends Component
  constructor: (props) ->
    super(props)
    @state =
      notesEntry: ''
      titleEntry: ''

  handleFormChange: (state) => @setState(state)

  handleFormSubmit: (state) =>
    tab =
      title: state.titleEntry
      notes: state.notesEntry
    console.log tab
    @props.socket.emit 'tab submission', tab
    @setState
      titleEntry: ''
      notesEntry: ''
    getTitles @props.socket, (titles) =>
      @props.setTab tab
      @props.setTitles titles

  render: ->
    that = this
    return Form
      className: 'form'
      value: @state
      onChange: that.handleFormChange
      onSubmit: that.handleFormSubmit,
      div {},
        label {},
          input
            type: 'text'
            name: 'titleEntry'
            placeholder: 'Tab Title'
      div {},
        label {},
          textarea
            type: 'text'
            name: 'notesEntry'
            placeholder: 'Enter a tab!'
      button
        type: 'submit'
        'Submit'

module.exports = TabInput
