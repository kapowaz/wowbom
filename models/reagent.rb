class Reagent
  include DataMapper::Resource

  property :id,             Serial, :key => true
  property :quantity,       Integer

  has 1, :item
  belongs_to :recipe
end