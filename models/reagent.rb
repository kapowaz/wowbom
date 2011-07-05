class Reagent
  include DataMapper::Resource

  property :id,         Serial
  property :quantity,   Integer

  belongs_to :component, :model => 'Item', :child_key => [:item_id]
  belongs_to :recipe, :child_key => [:recipe_id]
end