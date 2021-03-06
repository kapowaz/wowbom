require 'rubygems'
require 'sinatra/base'
require 'json'
require 'data_mapper'
require 'resque'
require 'hirefireapp'
require 'extlib'
require 'wowecon'
require 'wowget'

class Wowbom < Sinatra::Base
  
  set :views, File.dirname(__FILE__) + '/app/views'
  set :public, File.dirname(__FILE__) + '/public'
  
  PATCH_VERSION = Gem::Version.create("4.2.0")
  
  configure :development do
    DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:development]
    uri          = URI.parse YAML.load(File.new("config/redis.yml"))[:development][:instance]
    Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end
  
  configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
    uri          = URI.parse ENV["REDISTOGO_URL"]
    Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end
  
end

Dir[File.join(File.dirname(__FILE__), 'app/**/*.rb')].sort.each { |f| require f }

DataMapper.finalize
DataMapper.auto_upgrade!