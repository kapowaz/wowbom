require File.dirname(__FILE__) + '/spec_helper'

describe "Price" do
  describe "Fetch from wowecon.com" do
    before do
      @item  = Item.from_wowget(61981) # Inferno Ink
      @realm = Realm.first(:region => 'eu', :slug => "alonsus")
      @price = Price.from_wowecon :item => @item, :realm => @realm, :faction => :alliance
    end
    
    it "should be a Price" do
      @price.class.should == Price && @price.pending?.should == true
    end
  end
  
  describe "when requesting a price for a non-existent realm" do
    it "should return an error" do
      @item  = Item.from_wowget(61981)
      @realm = Realm.first(:region => 'eu', :slug => "foobar")
      @price = Price.from_wowecon :item => @item, :realm => @realm, :faction => :alliance
      @price.key?(:error).should == true && @price[:error].should == "invalid realm"
    end
  end
  
  describe "when requesting a price for a non-existent item" do
    it "should return an error" do
      @item  = Item.from_wowget(1) # doesn't exist
      @realm = Realm.first(:region => 'eu', :slug => "alonsus")
      @price = Price.from_wowecon :item => @item, :realm => @realm, :faction => :alliance
      @price.key?(:error).should == true && @price[:error].should == "non-existent item"
    end
  end
  
  # it "should return the most recent price for a given item, realm and faction" do
  #   true.should == false
  # end
  
end