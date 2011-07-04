require File.dirname(__FILE__) + '/spec_helper'

describe "Recipe" do
  
  it "should be instantiable using wowget" do
    recipe = Recipe.from_wowget(63188)
    recipe.name.should == "Battlelord's Plate Boots"
  end
  
end