React = require 'react'
{Component} = React
{div, input, button} = React.DOM

Form = React.createFactory (require 'react-form-controlled').default



class Toolbar extends Component

  constructor: ->
    @state =
      username: '',
      password: ''

  handleFormChange: (state) -> @setState(state)

  handleFormSubmit: (state) ->
    Auth.login(@state.username, @state.password)
      .catch (err) ->
        console.log("Error logging in", err)
    @setState(username: '', password: '')

  render: =>
    if @props.isLoggedIn
      return div className: 'toolbar', 'Hello user!'
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
        onClick: @props.toCreateUser

module.exports = Toolbar
