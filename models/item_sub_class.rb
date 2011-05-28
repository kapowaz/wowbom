class ItemSubClass
 include DataMapper::Resource
 
 property :id,             Integer, :key => true
 property :name,           String
 
 belongs_to :item
end