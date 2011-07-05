require File.join(File.dirname(__FILE__), '..', 'application.rb')

require 'rack/test'
require 'rspec'

RSpec.configure do |config|
  set :environment, :test
  
  config.before(:each) do 
    # DataMapper.auto_migrate!
  end
end