require File.dirname(__FILE__) + '/spec_helper'

describe "Price" do
  
  before :each do
    @currency = Wowecon::Currency.new({:gold => 1420, :silver => 9, :copper => 10})
  end
  
  describe "Updated from wowecon.com" do
    it "should be a Currency" do
      item_id = 61981 # Inferno Ink
      realm = Realm.first(:region => 'eu', :slug => "alonsus")
      price = Price.from_wowecon(item_id, :realm => realm, :faction => :alliance)
      
      price.class.should == DataMapper::Property::Currency
    end    
  end
  
end