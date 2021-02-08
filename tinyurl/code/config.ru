# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

Url::API.compile!

use Rack::Config do |env|
  # env['api.tilt.root'] = Rails.root.join('app', 'views')
  env['api.tilt.root'] = "#{Rails.root}/app/views"
  #{env['api.tilt.root']}/layouts/application.rabl
end

run Rails.application
