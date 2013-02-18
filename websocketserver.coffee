###
# WebSocket Server Setup
###
WebSocketServer = require("websocket").server
app = null
clients = {}

exports.init = (expressApp, webServer) ->
  app = expressApp
  app.set "clients", clients

  webSocketServer = new WebSocketServer
    httpServer: webServer
    autoAcceptConnections: false

  webSocketServer.on "request", (req) ->
    if originIsAllowed req.origin
      setupConnection req.accept(null, req.origin)
    else
      console.log "Socket connection denied from #{req.origin}"

setupConnection = (connection) ->
  ID = generateID()

  clients[ID] =
    connection: connection

  # Forward all messages to other clients
  connection.on "message", (message) ->
    for clientID, client of clients
      client.connection.sendUTF(message.utf8Data) unless clientID is ID

  connection.on "close", (reasonCode, description) ->
    delete clients[ID]

originIsAllowed = (origin) ->
  app.get("env") is "development" or origin is app.get "domain"

# UUID
generateID = ->
  "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
          r = Math.random() * 16 | 0
          v = (if c is "x" then r else (r & 0x3 | 0x8))
          return v.toString 16
