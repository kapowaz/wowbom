class Price
  include DataMapper::Resource
  
  property :id,             Serial, :key => true
  property :faction,        Enum[:alliance, :horde, :neutral]
  property :auction_price,  Currency
  property :updated_at,     DateTime
  
  has 1, :realm
  belongs_to :item
  
end