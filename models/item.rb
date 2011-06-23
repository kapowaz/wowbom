class Item
  include DataMapper::Resource
  
  # the primary key is a composite of :id, :realm and :auction_house
  property :id,             Integer, :key => true
  property :auction_house,  Enum[:alliance, :horde, :neutral], :key => true
  
  property :name,           String
  property :level,          Integer
  property :required_level, Integer
  property :quality_id,     Integer
  property :quality,        Enum[:poor, :common, :uncommon, :rare, :epic, :legendary, :artifact, :heirloom]
  property :inventory_slot, Integer
<<<<<<< HEAD
  property :vendor_price,   Currency
  property :auction_price,  Currency
=======
  property :vendor_price,   Float
  property :auction_price,  Float
>>>>>>> ddd9234cd707d34911e69d6ebfa3800e2036bf5b
  
  has 1, :realm, :key => true
  has 1, :spell
  has 1, :class
  has 1, :subclass
  has 1, :icon
  
  def quality.to_s
    self.quality.to_s.capitalize
  end
  
  def inventory_slot_name
    case self.inventory_slot
      when 1 then "Head"
      when 2 then "Neck"
      when 3 then "Shoulder"
      when 4 then "Shirt"
      when 5 then "Chest"
      when 6 then "Belt"
      when 7 then "Legs"
      when 8 then "Feet"
      when 9 then "Wrist"
      when 10 then "Gloves"
      when 11 then "Finger 1"
      when 12 then "Finger 2"
      when 13 then "Trinket 1"
      when 14 then "Trinket 2"
      when 15 then "Back"
      when 16 then "Main Hand"
      when 17 then "Off Hand"
      when 18 then "Ranged"
      when 19 then "Tabard"
      when 20 then "First Bag"
      when 21 then "Second Bag"
      when 22 then "Third Bag"
      when 23 then "Fourth Bag"
      else "None"
    end
  end
end