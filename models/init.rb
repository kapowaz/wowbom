require 'data_mapper'

# only for development
DataMapper::Logger.new $stdout, :debug

require_relative 'realm'
# require_relative 'currency'
# require_relative 'icon'
# require_relative 'item'
# require_relative 'item_class'
# require_relative 'item_sub_class'
# require_relative 'reagent'
# require_relative 'reagent_list'
# require_relative 'spell'

DataMapper.setup :default, YAML.load(File.new("config/database.yml"))[:development]
DataMapper.finalize
DataMapper.auto_upgrade!