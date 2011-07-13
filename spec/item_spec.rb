require File.dirname(__FILE__) + '/spec_helper'

describe "Item" do
  
  it "should be instantiable using wowget" do
    item_id = 55060
    
    Item.from_wowget(item_id)
    item = Item.get(item_id)
    
    item.name.should == "Elementium Deathplate" and
      item.recipe.name.should == "Elementium Deathplate" and
      item.recipe.reagents.length.should == 3 and
      item.recipe.reagents.first(:item_id => 53039).quantity.should == 5 and
      item.recipe.reagents.first(:item_id => 58480).quantity.should == 6 and
      item.recipe.reagents.first(:item_id => 52078).quantity.should == 3
  end
  
  describe "With an existing, outdated item" do
    it "should refresh the resource if the patch version has increased" do
      now      = Time.now()      
      outdated = Item.create({
        :id             => 36,
        :name           => "Worn Mace",
        :level          => 1,
        :quality_id     => 6,
        :required_level => 90,
        :inventory_slot => 16,
        :buy_price      => 0,
        :sell_price     => 0,
        :created_at     => now,
        :updated_at     => now,
        :icon           => Icon.create(:id => 999999, :name => "INV_fake_icon"),
        :category       => Category.first,
        :patch          => "1.11.1",
        :added_in       => "1.11.1"
      })
      outdated.refresh
      outdated.patch.to_s.should == "4.2.0" and outdated.quality_id.should == 1
    end
  end
  
  describe "With a text query matching multiple items" do
    it "should return an array of possible item matches" do
      query   = 'Titansteel'
      results = Item.from_query(query)
      
      results.length.should == 15 and 
        results.all? {|item| item.patch == Wowbom::PATCH_VERSION }.should == true and
        results.all? {|item| item.name.match(Regexp.new(query, true)) }.should == true
    end
  end
end