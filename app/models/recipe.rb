# encoding: utf-8
require 'wowget'

class Recipe
  include DataMapper::Resource

  property :id,             Integer,  :key => true
  property :name,           String
  property :profession_id,  Integer
  property :skill,          Integer
  property :item_quantity,  Range,    :default => "1..1"
  property :created_at,     DateTime, :default => lambda {|r, p| Time.now }
  property :updated_at,     DateTime, :default => lambda {|r, p| Time.now }
  property :patch,          Version,  :default => Wowbom::PATCH_VERSION
  property :added_in,       Version,  :default => Wowbom::PATCH_VERSION

  has n, :reagents

  def self.from_wowget(recipe_id, options={})
    if Recipe.get(recipe_id).nil?
      wowget_spell = Wowget::Spell.new(recipe_id)
      
      now = Time.now()
      recipe = Recipe.new(
        :id            => recipe_id,
        :name          => wowget_spell.name,
        :profession_id => wowget_spell.profession_id,
        :skill         => wowget_spell.skill,
        :item_quantity => wowget_spell.item_quantity_min..wowget_spell.item_quantity_max
      )
    
      if options[:debug]
        puts "Fetching recipe ##{recipe_id} " + "[#{wowget_spell.name}]".yellow
      end

      unless wowget_spell.reagents.nil?
        wowget_spell.reagents.each do |reagent|
          component = Item.get(reagent[:item].id) || Item.from_wowget(reagent[:item].id, options)
          reagent   = Reagent.create(:component => component, :quantity => reagent[:quantity], :recipe => recipe)
          recipe.reagents << reagent
        end
      end

      recipe.created_at = now
      recipe.updated_at = now

      if recipe.save
        recipe
      end
    else
      recipe = Recipe.get(recipe_id)
      
      # if the recipe's patch is from a previous one to the current patch, do an update
      if recipe.patch < Wowbom::PATCH_VERSION
        recipe.refresh
      else
        recipe
      end      
    end
  end
  
  def refresh(options={})
    wowget_spell = Wowget::Spell.new(self.id)
    
    if wowget_spell.error.nil?
      
      if options[:debug]
        puts "Refreshing recipe ##{self.id} " + "[#{wowget_spell.name}]".yellow
      end
      
      self.update(
        :name          => wowget_spell.name,
        :profession_id => wowget_spell.profession_id,
        :skill         => wowget_spell.skill,
        :item_quantity => wowget_spell.item_quantity_min..wowget_spell.item_quantity_max,
        :patch         => Wowbom::PATCH_VERSION
      )
      
      unless wowget_spell.reagents.nil?
        self.reagents.destroy
        wowget_spell.reagents.each do |reagent|
          component = Item.get(reagent[:item].id) || Item.from_wowget(reagent[:item].id, options)
          reagent   = Reagent.create(:component => component, :quantity => reagent[:quantity], :recipe => self)
          self.reagents << reagent
        end
      end
      
      self.updated_at = Time.now()
      self.save
      
      self.saved?
    end
  end
  
  def price(options={})
    total = 0
    self.reagents.each do |reagent|
      unless options[:realm].nil?
        unless options[:faction].nil?
          # price for a specific realm/faction
          
          component_price = Price.most_recent options.merge(:item => reagent.component)
          
          unless component_price.pending?
            vendor  = reagent.component.buy_price.to_i
            auction = component_price.kind_of?(Hash) && component_price.key?(:error) ? 0 : component_price.auction_price.to_i

            if (auction > 0 && vendor > 0 && vendor < auction) || vendor > 0
              puts "item ##{reagent.component.id} #{reagent.component.to_textlink} adding #{reagent.quantity} x #{vendor} (vendor price) to the total".blue if options[:debug]
              total += reagent.quantity * vendor
            else
              puts "item ##{reagent.component.id} #{reagent.component.to_textlink} adding #{reagent.quantity} x #{auction} (auction price) to the total".green if options[:debug]
              total += reagent.quantity * auction
            end            
          else
            # TODO: this needs to take into account the fact the price is now being queued with DJ
            # this price is still pending
            @pending_components = true
          end
        else
          # server average across all factions
          
          unless Price.all(:realm => options[:realm], :item => reagent.component).all? {|price| !price.nil? && Time.now.to_i - price.updated_at.to_time.to_i < 86400}
            Price.from_wowecon options.merge(:item => reagent.component)
          end
          
          vendor  = reagent.component.buy_price.to_i
          average = Price.avg(:auction_price, :item => reagent.component, :realm => options[:realm]).to_i

          if (average > 0 && vendor > 0 && vendor < average) || vendor > 0
            total += reagent.quantity * vendor
          else
            total += reagent.quantity * average
          end
        end
      else
        # average across all servers and factions
        reagent_prices = Price.all(:item => reagent.component)
        if reagent_prices.none? || reagent_prices.any? {|price| price.nil? || Time.now - price.updated_at.to_time > 86400}
          # this is going to be painfully slow :|
          Realm.all.each do |realm|
            [:alliance, :horde, :neutral].each do |faction|
              Price.most_recent :item => reagent.component, :realm => realm, :faction => faction, :debug => true
            end
          end
        end
        
        vendor  = reagent.component.buy_price.to_i
        average = Price.avg(:auction_price, :item => reagent.component).to_i

        if (average > 0 && vendor > 0 && vendor < average) || vendor > 0
          total += reagent.quantity * vendor
        else
          total += reagent.quantity * average
        end
      end
    end
    Wowecon::Currency.new(total)
  end
  
  def to_hash(options={})
    hash = {
      :id            => self.id,
      :name          => self.name,
      :profession    => self.profession,
      :profession_id => self.profession_id,
      :skill         => self.skill,
      :item_quantity => self.item_quantity,
      :created_at    => self.created_at,
      :updated_at    => self.updated_at,
      :patch         => self.patch,
      :added_in      => self.added_in,
    }
    
    hash[:reagents] = []
    self.reagents.each do |reagent|
      hash[:reagents] << {
        :component     => reagent.component.to_hash, 
        :quantity      => reagent.quantity, 
        :buy_price     => reagent.component.buy_price.to_i,
        :auction_price => reagent.component.auction_price(options).to_i
      }
    end
    
    hash
  end
  
  def to_textlink
    Colored.colorize "[#{self.name}]", :foreground => 'yellow'
  end

  def profession
    case self.profession_id
      when 1 then "Alchemy"
      when 2 then "Blacksmithing"
      when 3 then "Cooking"
      when 4 then "Enchanting"
      when 5 then "Engineering"
      when 6 then "First Aid"
      when 7 then "Jewelcrafting"
      when 8 then "Leatherworking"
      when 9 then "Mining"
      when 10 then "Tailoring"
      when 11 then "Yes"
      when 12 then "No"
      when 13 then "Fishing"
      when 14 then "Herbalism"
      when 15 then "Inscription"
      when 16 then "Archaeology"
    end
  end
  
  def pending_components?
    @pending_components.nil? ? false : @pending_components
  end
end