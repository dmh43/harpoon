React = require 'react'
{Component} = React
{div, input, button, span} = React.DOM

Form = React.createFactory (require 'react-form-controlled').default

class Toolbar extends Component

  constructor: ->
    @state =
      username: '',
      password: ''

  handleFormChange: (state) => @setState(state)

  handleFormSubmit: (state) =>
    user = {username: @state.username, password: @state.password}
    @setState username: '', password: ''
    @props.loginUser(user)

  render: =>
    if @props.username
      return div className: 'toolbar',
        span className: 'welcome-message',
          "Welcome, " + @props.username + "!"
        button
          onClick: @props.logoffUser
          'Logoff'
    return div
      className: 'toolbar',
      Form
        value: @state
        onChange: @handleFormChange
        onSubmit: @handleFormSubmit,
        input
          type: 'text'
          name: 'username'
          placeholder: 'username'
        input
          type: 'password'
          name: 'password'
          placeholder: 'Password'
        button
          type: 'submit'
          'Login'
      div
        className: 'signup'
        onClick: @props.toCreateUser,
        'Sign-up here!'

module.exports = Toolbar
