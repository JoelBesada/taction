###
# Express Bootstrap
###
express = require "express"
async = require "async"

app = express()

require("./config/environments").init app, express

webServer = require("./webserver").init app
webSocketServer = require("./websocketserver").init app, webServer

