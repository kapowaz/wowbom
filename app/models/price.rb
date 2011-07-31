# encoding: utf-8
require 'wowecon'

class Price
  include DataMapper::Resource
  
  property :id,             Serial
  property :faction,        Enum[:alliance, :horde, :neutral]
  property :source,         Enum[:wowecon, :user, :api]
  property :auction_price,  Currency,   :default => 0
  property :pending,        Boolean,    :default => true
  property :updated_at,     DateTime,   :required => false
  
  belongs_to :realm
  belongs_to :item
  
  @queue = :prices
  
  after :create do
    Resque.enqueue Price, self
  end

  def self.perform(params)
    price = Price.get params["id"]
    
    wowecon_price = Wowecon.price(price.item.name, {
      :server_name => price.realm.name, 
      :region      => price.realm.region.upcase,
      :faction     => price.faction.to_s[0].upcase
    })

    unless wowecon_price.key? :error
      price.attributes = {:auction_price => wowecon_price[:value], :pending => false, :updated_at => Time.now()}
      price.save
    end
  end
  
  def self.from_wowecon(options={})
    item = options[:item]
    
    unless item.nil?
      realm = options[:realm]

      unless realm.nil?
        puts "Fetching price for #{item.to_textlink} on realm #{realm.name}–#{realm.region} (#{options[:faction].to_s.upcase})…" if options[:debug]
        price = Price.create(
          :item          => item,
          :realm         => realm,
          :faction       => options[:faction],
          :source        => :wowecon
        )
      else
        {:error => "invalid realm"}
      end   
    else
      {:error => "non-existent item"}
    end
  end
  
  def self.most_recent(options={})
    price = Price.first options.merge(:pending => false, :order => [:updated_at.desc])
    
    if price.nil? || price.stale?
      Price.from_wowecon options
    else
      price
    end
  end
  
  def stale?
    Time.now.to_i - self.updated_at.to_time.to_i >= 86400 # 24 hours
  end
  
end