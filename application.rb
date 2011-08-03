require 'rubygems'
require 'sinatra/base'
require 'sinatra_warden'
require 'json'
require 'data_mapper'
require 'resque'
require 'hirefireapp'
require 'extlib'
require 'wowecon'
require 'wowget'

class Wowbom < Sinatra::Base

  register Sinatra::Warden
    
  set :views,         File.dirname(__FILE__) + '/app/views'
  set :public,        File.dirname(__FILE__) + '/public'
  set :auth_use_erb,  true

  # other Sinatra::Warden settings... (see https://github.com/jsmestad/sinatra_warden/wiki/Available-Overrides)
  # :auth_success_path  String/Proc # The path you want to redirect to on authentication success. Defaults to "/".
  # :auth_failure_path  String/Proc # The path you want to redirect to on authentication failure. (ex. "/error") Defaults to lambda { back }.
  # :auth_success_message String # The flash[:success] message to display (requires Rack::Flash). Defaults to "You have logged in successfully."
  # :auth_error_message String # The flash[:error] message to display (requires Rack::Flash). Defaults to "Could not log you in."
  # :auth_use_erb Boolean # Use ERB to render the login template instead of HAML. Defaults to false.
  # :auth_login_template # Symbol The path to the login form you want to use with Sinatra::Warden. Defaults to :login.
  
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