require File.join(File.dirname(__FILE__), '..', 'application.rb')

require 'rack/test'
require 'rspec'

RSpec.configure do |config|
  DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:test]
  DataMapper.auto_migrate!
  Category.populate_all!
  Realm.update_all!
end