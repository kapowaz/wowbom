require 'sinatra'
require 'data_mapper'
require 'wowecon'
require 'wowget'

class Wowbom < Sinatra::Application
  
  set :views, Proc.new { File.join(root, "app/views") }
  
  configure :test do
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:test]
  end
  
  configure :development do
    # DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:development]
  end
  
  configure :production do
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:production]
  end
  
end

require_relative 'app/lib/init'
require_relative 'app/models/init'
require_relative 'app/helpers/init'
require_relative 'app/routes/init'