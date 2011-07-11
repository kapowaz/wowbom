require File.dirname(__FILE__) + '/spec_helper'

describe "Recipe" do
  
  it "should be instantiable using wowget" do
    recipe_id = 63188
    
    Recipe.from_wowget(recipe_id)
    recipe = Recipe.get(recipe_id)
    
    recipe.name.should == "Battlelord's Plate Boots"
  end
  
  describe "with an existing, outdated recipe" do
    it "should refresh the recipe if the patch version has increased" do
      now      = Time.now()      
      outdated = Recipe.create({
        :id            => 2737,
        :name          => "Copper Mace",
        :profession_id => 2,
        :skill         => 10,
        :patch         => "1.11.1"
      })
      
      outdated.reagents << Reagent.create(:component => Item.from_wowget(2840), :quantity => 8, :recipe => outdated)
      outdated.reagents << Reagent.create(:component => Item.from_wowget(2880), :quantity => 2, :recipe => outdated)
      outdated.reagents << Reagent.create(:component => Item.from_wowget(2589), :quantity => 4, :recipe => outdated)
      
      outdated.refresh
      
      outdated.patch.to_s.should == "4.2.0" and 
        outdated.skill.should == 15 and
        outdated.reagents.length.should == 3 and
        outdated.reagents.first(:item_id => 2840).quantity.should == 6 and
        outdated.reagents.first(:item_id => 2880).quantity.should == 1 and
        outdated.reagents.first(:item_id => 2589).quantity.should == 2
        
    end
  end
  
end