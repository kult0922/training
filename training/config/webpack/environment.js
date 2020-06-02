const { environment } = require('@rails/webpacker')
const path = require('path')

environment.config.resolve.alias = {
  '@style': path.resolve('app/frontend/stylesheets')
}

module.exports = environment
