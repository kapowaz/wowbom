class Reagentlist
 include DataMapper::Resource
 
 property :id,             Serial
 
 belongs_to :spell
 belongs_to :reagent
end