require File.dirname(__FILE__) + '/spec_helper'

# testable?

describe "Realm" do
  it "can update all realms from battle.net using the community platform API" do
    Realm.update_all!
    Realm.any?.should == true
  end
  
  describe "With an existing realm" do
    it "can be updated from battle.net using the community platform API" do
      realm = Realm.first(:slug => "alonsus", :region => "eu")
      realm.update_from_api.should == true
    end
  end
end