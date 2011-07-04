require File.dirname(__FILE__) + '/spec_helper'

describe "Item" do
  
  it "should be instantiable using wowget" do
    item = Item.from_wowget(45559)
    item.name.should == "Battlelord's Plate Boots"
  end
  
end