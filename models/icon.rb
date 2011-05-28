class Icon
 include DataMapper::Resource
 
 property :id,             Integer, :key => true
 property :name,           String
end