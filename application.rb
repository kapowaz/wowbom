require 'sinatra'
require 'data_mapper'
require 'wowecon'
require 'wowget'

class Wowbom < Sinatra::Application
  
  configure :test do
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:test]
  end
  
  configure :development do
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:development]
  end
  
  configure :production do
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:production]
  end
  
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'