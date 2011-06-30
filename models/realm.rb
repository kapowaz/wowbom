class Realm
  include DataMapper::Resource
  
  property :id,             Serial, :key => true
  property :status,         Boolean
  property :slug,           String
  property :population,     String
  property :type,           String  
  property :queue,          Boolean
  property :name,           String    
  property :region,         String
  property :locale,         String

end