class Spell
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