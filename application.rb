require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'wowecon'
require 'wowget'

class Wowbom < Sinatra::Application
  
  set :views, Proc.new { File.join(root, "app/views") }
  
  PATCH_VERSION = "4.2.0"
  
  configure :test do
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:test]
  end
  
  configure :development do
    # DataMapper::Logger.new($stdout, :debug)
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:development]
  end
  
  configure :production do
    # N.B. Heroku-provided postgres DB in production
    DataMapper.setup(:default, ENV['DATABASE_URL'])
  end
  
end

Dir[File.join(File.dirname(__FILE__), 'app/**/*.rb')].sort.each { |f| require f }

DataMapper.finalize
DataMapper.auto_upgrade!