require File.dirname(__FILE__) + '/spec_helper'

describe "Recipe" do
  
  it "should be instantiable using wowget" do
    recipe_id = 63188
    
    Recipe.from_wowget(recipe_id)
    recipe = Recipe.get(recipe_id)
    
    recipe.name.should == "Battlelord's Plate Boots"
  end
  
end