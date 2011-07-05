# encoding: utf-8
require 'wowecon'

class Price
  include DataMapper::Resource
  
  property :id,             Serial, :key => true
  property :faction,        Enum[:alliance, :horde, :neutral]
  property :auction_price,  Currency
  property :updated_at,     DateTime
  
  belongs_to :realm
  belongs_to :item
  
  def self.from_wowecon(item_id, options={})
    item = Item.get(item_id)
    unless item.nil?
      realm = options[:realm]
      
      wowecon_price = Wowecon::Currency.new(Wowecon.price(item.name, 
        :server_name => realm.name, 
        :region => realm.region, 
        :faction => options[:faction][0].upcase)[:float])
      
      if options[:debug]
        puts "Fetching price for [#{item.name}] on realm #{realm.name}–#{realm.region} (#{options[:faction].to_s.upcase}): #{wowecon_price}"
      end
      
      now = Time.now()
      price = Price.new(
        :faction       => options[:faction],
        :auction_price => wowecon_price,
        :updated_at    => now,
        :realm         => realm,
        :item          => item
      )
      
      price.save
      price
    end
  end
  
end