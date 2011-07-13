# encoding: utf-8
require 'wowecon'

class Price
  include DataMapper::Resource
  
  property :faction,        Enum[:alliance, :horde, :neutral]
  property :auction_price,  Currency
  property :updated_at,     DateTime
  
  belongs_to :realm, :key => true
  belongs_to :item, :key => true
  
  def self.from_wowecon(item_id, options={})
    item = Item.from_wowget(item_id)
    unless item.nil?
      realm = options[:realm]
      
      unless realm.nil?
        wowecon_options = {
          :server_name => realm.name, 
          :region => realm.region.upcase, 
          :faction => options[:faction][0].upcase
        }
        wowecon_price = Wowecon.price(item.name, wowecon_options)

        if options[:debug]
          puts "Fetching price for [#{item.name}] on realm #{realm.name}–#{realm.region} (#{options[:faction].to_s.upcase}): #{wowecon_price}"
        end

        unless wowecon_price.key? :error
          now = Time.now()
          existing = Price.first(:item => item, :realm => realm, :faction => options[:faction])
          
          unless existing.nil?
            existing.attributes = {:auction_price => wowecon_price[:value], :updated_at => now}
            existing.save
            existing
          else
            price = Price.new(
              :item          => item,
              :realm         => realm,
              :faction       => options[:faction],
              :auction_price => wowecon_price[:value],
              :updated_at    => now
            )
            price.save
            price
          end
        else
          # we weren't able to retrieve a price — but we may already have a price in the database, so we should try to return that first
          existing = Price.first(options.merge :item => item)
          
          unless existing.nil?
            existing
          else
            {:error => wowecon_price[:error]}
          end
        end
      else
        {:error => "invalid realm"}
      end
    else
      {:error => "non-existent item"}
    end
  end
  
end