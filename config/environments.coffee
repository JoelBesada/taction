###
# Environment Configuration
###
exports.init = (app, express) ->

  # General
  app.configure ->
    # app.use express.favicon("#{__dirname}/../public/images/favicon.ico")
    app.use express.logger "dev" if process.env.EXPRESS_LOG
    app.use express.cookieParser()
    app.use express.methodOverride()
    app.use app.router
    app.use require("connect-assets")()
    app.use express.static("#{__dirname}/../public")

    app.set "port", process.env.PORT or 3000
    app.set "views", "#{__dirname}/../views"
    app.set "view engine", "ejs"

  # Development
  app.configure "development", ->
    app.use express.errorHandler()

    app.set "port", process.env.PORT or 4000
