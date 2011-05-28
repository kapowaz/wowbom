class Realm
  include DataMapper::Resource
  
  property :id,             Integer, :key => true
  property :region,         String
  property :population,     String
  property :type,           String
  property :status,         String
  property :locale,         String
  property :name,           String
end