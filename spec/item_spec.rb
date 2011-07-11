require File.dirname(__FILE__) + '/spec_helper'

describe "Item" do
  
  it "should be instantiable using wowget" do
    item_id = 45559
    
    Item.from_wowget(item_id)
    item = Item.get(item_id)
    
    item.name.should == "Battlelord's Plate Boots"
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
        :patch          => "1.11.1"
      })
      outdated.refresh
      outdated.patch.to_s.should == "4.2.0" and outdated.quality_id.should == 1
    end
  end
  
end