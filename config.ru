require 'bundler/setup'
require 'rubim'
require 'rack/unreloader'
Unreloader = Rack::Unreloader.new{App}
require 'roda'

Unreloader.require './rubim.rb'
Unreloader.require './app.rb'

run Unreloader