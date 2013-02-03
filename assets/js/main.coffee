#= require_tree lib

$body = null
connection = null
touchPoints = {}

# Displays a single touch point on the screen
class TouchPoint
  constructor: (@id) ->
    @$el = @createElement()
    $body.append @$el
    @$el.addClass "show"

  createElement: ->
    $("<div>")
      .addClass("touch-point")
      .css(
        "background-color",
        "rgba(#{_.random 255}, #{_.random 255}, #{_.random 255}, 0.5)"
      )

  move: (x, y) ->
    @$el.css
      "webkit-transform": "translateX(#{x * document.width}px)
                           translateY(#{y * document.height}px)
                           translateZ(0)"

  remove: ->
    @$el.removeClass "show"
    setTimeout(=>
      @$el.remove()
    , 250)

$ ->
  $body = $ "body"
  connection = new WebSocket("ws://#{window.location.hostname}:#{SOCKET_PORT}")
  connection.onopen = setupTouchListeners

  # Listen for incoming messages (touch input from other devices)
  # and render it out on the page
  connection.onmessage = (e) ->
    data = JSON.parse e.data
    for touch in data.touches
      if data.start
        touchPoints[touch.id] = new TouchPoint(touch.id)
      else if data.end
        touchPoints[touch.id]?.remove()
        delete touchPoints[touch.id]
        continue

      touchPoints[touch.id]?.move touch.x, touch.y

# Listen for touch events and send them out through the socket
setupTouchListeners = ->
  return unless !!('ontouchstart' of window)

  $(document).on "touchstart", (e) ->
    e.preventDefault()
    sendMessage
      start: true
      touches: formatTouches e.originalEvent.changedTouches

  $(document).on "touchmove", (e) ->
    e.preventDefault()
    sendThrottledMessage
      touches: formatTouches e.originalEvent.changedTouches

  $(document).on "touchend touchcancel touchleave", (e) ->
    e.preventDefault()
    sendMessage
      end: true
      touches: formatTouches e.originalEvent.changedTouches

sendMessage = (message) ->
  connection.send JSON.stringify(message)

sendThrottledMessage = _.throttle(sendMessage, 10)

# Pick out the info we are interested in from the list of touches
formatTouches = (touches) -> {
  id: touch.identifier
  x: touch.screenX / document.width
  y: touch.screenY / document.height
} for touch in touches
