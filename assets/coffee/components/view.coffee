React = require 'react'
{Component} = React
{div, h1, input, button} = React.DOM

Form = React.createFactory (require 'react-form-controlled').default

tabsection = React.createFactory require './tabsection'
tabinput = React.createFactory require './tabinput'

class View extends Component
  constructor: (props) ->
    super(props)
    @state =
      usernameEntry: ''
      passwordEntry: ''
      passwordConfirmationEntry: ''

  handleFormChange: (state) =>
    @setState(state)

  handleFormSubmit: (state) =>
    if @state.passwordEntry != @state.passwordConfirmationEntry
      return
    user = {username: @state.usernameEntry, password: @state.passwordEntry}
    @props.socket.emit 'new user', user
    @setState
      usernameEntry: ''
      passwordEntry: ''
      passwordConfirmationEntry: ''

  tabview: ->
    return div className: 'tabView',
      tabsection
        className: 'tabSection'
        tab: @props.tab
      tabinput
        className: 'tabInput'
        socket: @props.socket
        setTab: @props.setTab
        setTitles: @props.setTitles

  signupView: ->
    return div className: 'signupView',
      Form
        className: 'form'
        value: @state
        onChange: @handleFormChange
        onSubmit: @handleFormSubmit,
        h1 {}, "Sign up!",
        div {}
          input
            type: 'text'
            name: 'usernameEntry'
            placeholder: 'username'
        div className: 'passwords',
          div {}
            input
              type: 'password'
              name: 'passwordEntry'
              placeholder: 'password'
          div {}
            input
              type: 'password'
              name: 'passwordConfirmationEntry'
              placeholder: 'confirm password'
        button
          type: 'submit'
          'Submit'

  render: ->
    view =
      switch @props.view
        when 'tabview'
          @tabview()
        when 'signupView'
          @signupView()
    return div
      className: 'view',
      view


module.exports = View
