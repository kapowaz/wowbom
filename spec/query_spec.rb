require File.dirname(__FILE__) + '/spec_helper'

describe "Query" do
  
  fresh_query    = "titansteel"
  stale_query    = "copper"
  new_query      = "ebonsteel"
  now            = Time.now

  Query.create(:text => fresh_query, :created_at => now, :updated_at => now, :patch => Wowbom::PATCH_VERSION)
  Query.create(:text => stale_query, :created_at => now, :updated_at => now, :patch => Gem::Version.new("2.1.0"))

  describe "#fresh?" do
    it "should return true for a fresh query" do
      Query.fresh?(fresh_query).should == true
    end
    
    it "should return false for a stale query" do
      Query.fresh?(stale_query).should == false
    end
  end

  describe "#refresh!" do
    it "should refresh an existing stale query" do
      Query.refresh!(stale_query)
      Query.fresh?(stale_query).should == true
    end
    
    it "should create a new entry for a non-existent query" do
      Query.refresh!(new_query)
      Query.fresh?(new_query).should == true
    end
  end
  
  Query.all(:text => fresh_query).destroy
  Query.all(:text => stale_query).destroy
  Query.all(:text => new_query).destroy
end