require_relative 'realm'
require_relative 'currency'
require_relative 'item'
require_relative 'category'
require_relative 'price'
require_relative 'icon'
require_relative 'reagent'
require_relative 'recipe'

DataMapper.finalize
DataMapper.auto_upgrade!