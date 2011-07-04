require 'wowget'

class Recipe
  include DataMapper::Resource

  property :id,             Integer, :key => true
  property :name,           String
  property :profession_id,  Integer
  property :skill,          Integer
  property :created_at,     DateTime
  property :updated_at,     DateTime

  has 1, :item
  has n, :reagents

  def self.from_wowget(recipe_id)
    if Recipe.get(recipe_id).nil?
      wowget_spell = Wowget::Spell.new(recipe_id)
      
      now = Time.now()
      recipe = Recipe.new(
        :id            => recipe_id,
        :name          => wowget_spell.name,
        :profession_id => wowget_spell.profession_id,
        :skill         => wowget_spell.skill
      )

      unless wowget_spell.reagents.nil?
        wowget_spell.reagents.each do |reagent|
          item = Item.get(reagent[:item].id) || Item.from_wowget(reagent[:item].id)
          recipe.reagents << Reagent.create(:item => item, :quantity => reagent[:quantity])
        end        
      end

      recipe.created_at = now
      recipe.updated_at = now

      if recipe.save
        recipe
      end
    else
      Recipe.get(recipe_id)
    end
  end

  def profession
    case self.profession_id
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