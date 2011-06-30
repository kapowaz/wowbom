require 'sinatra'
require 'wowget'

class WowBom < Sinatra::Application
  configure :development do
    # ...
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'