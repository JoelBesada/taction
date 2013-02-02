#= require_tree lib

$circle = null
connection = null
$ ->
  $circle = $ ".circle"

  connection = new WebSocket("ws://#{window.location.hostname}:#{SOCKET_PORT}")
  connection.onopen = setupTouchListeners

  connection.onmessage = (e) ->
    data = JSON.parse e.data
    if data.start
      $circle.addClass "show"
    else if data.end
      $circle.removeClass "show"
      return

    moveCircle data.x * document.width, data.y * document.height

setupTouchListeners = ->
  return unless !!('ontouchstart' of window)

  $(document).on "touchstart", (e) ->
    sendMessage
      start: true
      x: e.originalEvent.pageX / document.width
      y: e.originalEvent.pageY / document.height

    e.preventDefault()

  $(document).on "touchmove", (e) ->
    sendMessage
      x: e.originalEvent.pageX / document.width
      y: e.originalEvent.pageY / document.height

  $(document).on "touchend", (e) ->
    sendMessage end: true

sendMessage = _.throttle((message) ->
  connection.send JSON.stringify(message)
, 10)

moveCircle = (x, y) ->
  $circle.css
    left: x - 20
    top: y - 20
