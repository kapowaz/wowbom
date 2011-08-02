# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "Recipe" do
  
  it "should be instantiable using wowget" do
    recipe_id = 63188
    
    Recipe.from_wowget(recipe_id)
    recipe = Recipe.get(recipe_id)
    
    recipe.name.should == "Battlelord's Plate Boots"
  end
  
  describe "has a total component cost" do
    recipe_id = 76445
    realms    = Realm.first(3)
    prices    = [750000, 5500000, 5000000]
    now       = Time.now
    
    Recipe.from_wowget(recipe_id)
    recipe = Recipe.get(recipe_id)
    
    realms.each_with_index do |realm, n|
      recipe.reagents.each_with_index do |reagent, i|
        Price.create(
          :item          => reagent.component, 
          :auction_price => prices[i] * (n+1), 
          :pending       => false, 
          :updated_at    => now, 
          :realm         => realm, 
          :faction       => :alliance, 
          :source        => :wowecon
        )
          
        Price.create(
          :item          => reagent.component, 
          :auction_price => (prices[i] * (n+1) * 1.25).to_i, 
          :pending       => false, 
          :updated_at    => now,
          :realm         => realm, 
          :faction       => :horde, 
          :source        => :wowecon
        )
      end
    end

    it "should have a total cost for a given realm and faction" do
      recipe.price(:realm => realms[0], :faction => :alliance).should == Wowecon::Currency.new(51750000)
      recipe.price(:realm => realms[0], :faction => :horde).should == Wowecon::Currency.new(64687500)
    end
    
    it "should have an average total cost across all factions on a given realm" do
      recipe.price(:realm => realms[0]).should == Wowecon::Currency.new(58218750)
      recipe.price(:realm => realms[1]).should == Wowecon::Currency.new(116437500)
      recipe.price(:realm => realms[2]).should == Wowecon::Currency.new(174656250)
    end
    
    it "should have an average total cost across all factions and realms" do
      recipe.price.should == Wowecon::Currency.new(116437500)
    end
  end
  
  describe "with an existing, outdated recipe" do
    it "should refresh the recipe if the patch version has increased" do
      now      = Time.now()      
      outdated = Recipe.create(
        :id            => 2737,
        :name          => "Copper Mace",
        :profession_id => 2,
        :skill         => 10,
        :patch         => "1.11.1",
        :added_in      => "1.11.1",
      )
      
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
  
  describe "with a recipe that can produce a variable quantity of items" do    
    it "should have a range property" do
      recipe_id = 78866

      Recipe.from_wowget(recipe_id)
      recipe = Recipe.get(recipe_id)

      recipe.name.should == "Transmute: Living Elements" and
        recipe.item_quantity.should == (14..16)
    end
  end
  
end