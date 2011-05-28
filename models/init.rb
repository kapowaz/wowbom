require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, YAML.load(File.new("config/database.yml"))[Sinatra::Application.environment()])
#DataMapper.finalize
#DataMapper.auto_migrate!

require_relative 'icon'
require_relative 'item'
require_relative 'item_class'
require_relative 'item_sub_class'
require_relative 'reagent'
require_relative 'reagent_list'
require_relative 'realm'
require_relative 'spell'