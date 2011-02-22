class Item
  include DataMapper::Resource
  
  property :id,             Integer, :key => true
  property :name,           String
  property :level,          Integer
  property :quality_id,     Integer
  property :quality,        Enum[:poor, :common, :uncommon, :rare, :epic, :legendary, :artifact, :heirloom]
  property :class,          Integer
  property :subclass,       Integer
  property :icon,           String
  property :inventory_slot, Integer
  property :created_by,     Integer
  
  has n, :recipes
end

class Recipe
  include DataMapper::Resource
  
  property :id,             Integer, :key => true
  property :name,           String
  property :profession,     Integer
  property :skill,          Integer
  property :cast_time,      Integer
  
  belongs_to :item
  has n, :reagentlists
  has n, :reagents, :through => :reagentlists
  
  def profession_name
    case self.profession
      when 1 then "Alchemy"
      when 2 then "Blacksmithing"
      when 3 then "Cooking"
      when 4 then "Enchanting"
      when 5 then "Engineering"
      when 6 then "First Aid"
      when 7 then "Jewelcrafting"
      when 8 then "Leatherworking"
      when 9 then "Mining"
      when 10 then "Tailoring"
      when 11 then "Yes"
      when 12 then "No"
      when 13 then "Fishing"
      when 14 then "Herbalism"
      when 15 then "Inscription"
      when 16 then "Archaeology"
    end
  end
end

class Reagent
  include DataMapper::Resource
  
  property :id,             Serial
  property :item_id,        Integer
  property :quantity,       Integer
  
  has n, :reagentlists
  has n, :recipes, :through => :reagentlists
end

class Reagentlist
  include DataMapper::Resource
  
  property :id,             Serial
  
  belongs_to :recipe
  belongs_to :reagent
end

class ItemClass
  include DataMapper::Resource
  
  property :id,             Integer, :key => true
  property :name,           String
  
  belongs_to :item
end

class ItemSubClass
  include DataMapper::Resource
  
  property :id,             Integer, :key => true
  property :name,           String
  
  belongs_to :item
end

class Icon
  include DataMapper::Resource
  
  property :id,             Integer, :key => true
  property :name,           String
  
  belongs_to :item
end

class InventorySlot
  include DataMapper::Resource
  
  property :id,             Integer, :key => true
  property :name,           String
  
  belongs_to :item
end