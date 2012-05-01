_ = require 'underscore'
path = require 'path'

module.exports = (options) ->
  options.root or= path.join __dirname, "..", ".."

  # Set local env variables
  try _.extend process.env, require path.join(options.root, 'env') catch err

  # Require modules
  express = require 'express'
  assets = require 'connect-assets'
  templates = require 'templates'

  # Require monkey patches
  require 'express-resource'
  require 'devcon'

  # Create express app
  app = express.createServer()

  # Settings
  app.set 'views', "#{options.root}/views"
  app.set 'view engine', 'jade'

  # Express middleware
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use templates(src: "#{options.root}/views")
  app.use assets(src: "#{options.root}/assets")
  app.use app.router
  app.use express.static("#{options.root}/assets")

  # Configure for development
  app.configure 'development', ->
    app.use express.errorHandler( dumpExceptions: true, showStack: true )

  # Configure for production
  app.configure 'production', ->
    app.use express.errorHandler()

  # Set global view variables
  app.dynamicHelpers
    baseUrl: (req, res) -> 'http://' + req.header 'host'

  # Return app
  app