require File.dirname(__FILE__) + '/spec_helper'

describe "Item" do
  
  it "should be instantiable using wowget" do
    item_id = 45559
    
    Item.from_wowget(item_id)
    item = Item.get(item_id)
    
    item.name.should == "Battlelord's Plate Boots"
  end
  
end