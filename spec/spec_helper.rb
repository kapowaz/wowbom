require File.join(File.dirname(__FILE__), '..', 'application.rb')

require 'rack/test'
require 'rspec'

set :environment, :test

RSpec.configure do |config|
  config.before(:each) do 
    # DataMapper.auto_migrate!
  end
end