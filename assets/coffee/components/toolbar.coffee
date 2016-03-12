React = require 'react'
{Component} = React
{div, input, button} = React.DOM

Form = React.createFactory (require 'react-form-controlled').default



class Toolbar extends Component

  getInitialState: ->
    return {
      username: '',
      password: ''
    }

  handleFormChange: (state) -> @setState(state)

  handleFormSubmit: (state) ->
    @setState(username: '', password: '')

  render: =>
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
