# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Recipe" do
  
  it "should be instantiable using wowget" do
    recipe_id = 63188
    
    Recipe.from_wowget(recipe_id)
    recipe = Recipe.get(recipe_id)
    
    recipe.name.should == "Battlelord's Plate Boots"
  end
  
  it "should have a total cost based on its components’ cost" do
    recipe_id = 76445
    Recipe.from_wowget(recipe_id)

    # create some faked price data for this recipe's reagents
    realm = Realm.first(:slug => 'alonsus')
    now   = Time.now

    Price.create(:item => Item.from_wowget(53039), :auction_price => 750000, :updated_at => now, :realm => realm, :faction => :alliance)
    Price.create(:item => Item.from_wowget(58480), :auction_price => 5500000, :updated_at => now, :realm => realm, :faction => :alliance)
    Price.create(:item => Item.from_wowget(52078), :auction_price => 5000000, :updated_at => now, :realm => realm, :faction => :alliance)
    
    recipe = Recipe.get(recipe_id)
    recipe.price(:realm => realm, :faction => :alliance).should == Wowecon::Currency.new(51750000)
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
    
    it "should refresh the total recipe price if the existing data is outdated" do
      
      recipe_id = 76443
      Recipe.from_wowget(recipe_id)
      
      realm  = Realm.first(:slug => 'alonsus')
      past   = Time.mktime('2011-01-01 00:00')
      recipe = Recipe.get(recipe_id)

      {53039 => 1000000, 58480 => 9000000, 52078 => 10000000}.each_pair do |item_id, auction_price|
        price = Price.first(:item => Item.from_wowget(item_id), :realm => realm, :faction => :alliance)
        price.update(:auction_price => auction_price, :updated_at => past)
      end
      
      recipe.update_price(:realm => realm, :faction => :alliance)
      recipe.reagents.each do |reagent|
        component_price = Price.first(:realm => realm, :faction=> :alliance, :item => reagent.component)        
        component_price.updated_at.to_time.should >= Time.at(past)
      end
    end
  end
  
end