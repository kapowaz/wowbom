class Reagent
 include DataMapper::Resource
 
 property :id,             Serial
 property :item_id,        Integer
 property :quantity,       Integer
 
 has n, :reagentlists
 has n, :spells, :through => :reagentlists
end