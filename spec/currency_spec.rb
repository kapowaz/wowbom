require File.dirname(__FILE__) + '/spec_helper'

describe "DataMapper::Property::Currency" do
  before :all do
    class ::User
      include DataMapper::Resource

      property :id,       Serial
      property :currency, Currency
    end

    @property     = User.properties[:currency]
    @currency_int = 12345
    @currency     = Wowecon::Currency.new(@currency_int)
  end
  
  describe "#dump" do
    it "returns the currency value as an integer" do
      @property.dump(@currency).should == @currency_int
    end
    
    describe "when given nil" do
      it "returns nil" do
        @property.dump(nil).should be_nil
      end
    end
    
    describe 'when given zero' do
      it 'returns zero' do
        @property.dump(0).should == 0
      end
    end
  end
  
  describe "#load" do
    it "returns the integer as a currency" do
      @property.load(@currency_int).should == @currency
    end
    
    describe 'when given nil' do
      it 'returns nil' do
        @property.load(nil).should be_nil
      end
    end
    
    describe 'when given zero' do
      it 'returns a currency value of zero' do
        @property.load(0).should == Wowecon::Currency.new(0)
      end
    end
  end
  
  describe '#typecast' do
    describe 'given instance of Wowecon::Currency' do
      it 'does nothing' do
        @property.typecast(@currency).should == @currency
      end
    end

    describe 'when given an integer' do
      it 'delegates to #load' do
        @property.typecast(@currency_int).should == @currency
      end
    end
  end
  
end