require File.dirname(__FILE__) + '/spec_helper'

describe "DataMapper::Property::Version" do
  before :all do
    class ::User
      include DataMapper::Resource

      property :id,       Serial
      property :version,  Version
    end

    @property       = User.properties[:version]
    @version_string = "4.2.1"
    @version        = Gem::Version.create(@version_string)
  end
  
  describe "#dump" do
    it "returns the version value as a string" do
      @property.dump(@version).should == @version_string
    end
    
    describe "when given nil" do
      it "returns nil" do
        @property.dump(nil).should be_nil
      end
    end
    
    describe 'when given zero' do
      it 'returns the string "0"' do
        @property.dump(0).should == "0"
      end
    end
  end
  
  describe "#load" do
    it "returns the string as a version" do
      @property.load(@version_string).should == @version
    end
    
    describe 'when given nil' do
      it 'returns nil' do
        @property.load(nil).should be_nil
      end
    end
  end
  
  describe '#typecast' do
    describe 'given instance of Gem::Version' do
      it 'does nothing' do
        @property.typecast(@version).should == @version
      end
    end

    describe 'when given a string' do
      it 'delegates to #load' do
        @property.typecast(@version_string).should == @version
      end
    end
  end
  
end