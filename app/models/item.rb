# encoding: utf-8
require 'wowget'

class Item
  include DataMapper::Resource
  
  property :id,             Integer, :key => true
  property :name,           String
  property :level,          Integer
  property :quality_id,     Integer
  property :required_level, Integer
  property :inventory_slot, Integer
  property :buy_price,      Currency
  property :sell_price,     Currency
  property :soulbound,      Boolean
  property :created_at,     DateTime
  property :updated_at,     DateTime
  property :patch,          Version
  property :added_in,       Version
  
  belongs_to :icon
  belongs_to :category
  belongs_to :recipe, :required => false
  
  has n, :price
  
  validates_presence_of :name
  validates_numericality_of :level, :quality_id
  
  def self.from_query(query, options={})
    unless Query.fresh?(query.downcase.strip)
      result = Wowget::Item.find(query)
      if result.kind_of? Array
        result.each do |item|
          Item.from_wowget(item.id, options.merge(:item_from_query => item))
        end
      else
        Item.from_wowget(result.id, options.merge(:item_from_query => result))
      end
      Query.refresh!(query.downcase.strip)
    end
    
    Item.all(:name.like => "%#{query}%")
  end
  
  def self.from_wowget(item_id, options={})
    if Item.get(item_id).nil?

      wowget_item = options[:item_from_query] || Wowget::Item.find(item_id)
      if wowget_item.error.nil?
        
        if options[:debug]
          puts "Fetching item ##{item_id} #{wowget_item.to_link}"
        end
        
        options.delete :item_from_query if options.key? :item_from_query

        recipe   = wowget_item.recipe_id.nil? ? nil : Recipe.from_wowget(wowget_item.recipe_id, options)
        icon     = Icon.get(wowget_item.icon_id) || Icon.create(:id => wowget_item.icon_id, :name => wowget_item.icon_name)
        category = Category.first(:id => wowget_item.category_id, :subcategory_id => wowget_item.subcategory_id)
        now      = Time.now()

        item = Item.new(
          :id             => item_id,
          :name           => wowget_item.name,
          :level          => wowget_item.level,
          :quality_id     => wowget_item.quality_id,
          :required_level => wowget_item.required_level,
          :inventory_slot => wowget_item.inventory_slot_id,
          :buy_price      => wowget_item.buy_price,
          :sell_price     => wowget_item.sell_price,
          :soulbound      => wowget_item.soulbound,
          :created_at     => now,
          :updated_at     => now,
          :icon           => icon,
          :category       => category,
          :patch          => Wowbom::PATCH_VERSION,
          :added_in       => Wowbom::PATCH_VERSION,
        )
        item.recipe = recipe unless recipe.nil?
        item.save
        item
        
      else
        # nothing was found (and error raised)
      end
    else
      item = Item.get(item_id)
      
      # if the item's patch is from a previous one to the current patch, do an update
      if item.patch < Wowbom::PATCH_VERSION
        item.refresh
      else
        item
      end
    end
  end
  
  def refresh(options={})
    wowget_item = Wowget::Item.find(self.id)
    if wowget_item.error.nil?
      
      if options[:debug]
        puts "Refreshing item ##{self.id} #{wowget_item.to_link}"
      end
      
      recipe   = wowget_item.recipe_id.nil? ? nil : Recipe.from_wowget(wowget_item.recipe_id, options)
      icon     = Icon.get(wowget_item.icon_id) || Icon.create(:id => wowget_item.icon_id, :name => wowget_item.icon_name)
      category = Category.first(:id => wowget_item.category_id, :subcategory_id => wowget_item.subcategory_id)

      self.update(
        :name           => wowget_item.name,
        :level          => wowget_item.level,
        :quality_id     => wowget_item.quality_id,
        :required_level => wowget_item.required_level,
        :inventory_slot => wowget_item.inventory_slot_id,
        :buy_price      => wowget_item.buy_price,
        :sell_price     => wowget_item.sell_price,
        :soulbound      => wowget_item.soulbound,
        :updated_at     => Time.now(),
        :icon           => icon,
        :category       => category,
        :patch          => Wowbom::PATCH_VERSION
      )
      
      self.update :recipe => recipe unless recipe.nil?
      
      self.saved?
    end
  end
  
  def price_for(options={})
    unless self.recipe.nil?
      self.recipe.price(options)
    else
      self.buy_price
    end
  end
  
  def quality
    [:poor, :common, :uncommon, :rare, :epic, :legendary, :artifact, :heirloom][self.quality_id].to_s.capitalize
  end
  
  def to_link
    color = case self.quality.downcase.to_sym
    when :poor then 'white'
    when :common then 'white'
    when :uncommon then 'green'
    when :rare then 'blue'
    when :epic then 'magenta'
    when :legendary then 'red'
    when :artifact then 'yellow'
    when :heirloom then 'yellow'
    end
    Colored.colorize "[#{self.name}]", :foreground => color
  end
  
  def inventory_slot_name
    case self.inventory_slot
      when 1 then "Head"
      when 2 then "Neck"
      when 3 then "Shoulder"
      when 4 then "Shirt"
      when 5 then "Chest"
      when 6 then "Belt"
      when 7 then "Legs"
      when 8 then "Feet"
      when 9 then "Wrist"
      when 10 then "Gloves"
      when 11 then "Finger 1"
      when 12 then "Finger 2"
      when 13 then "Trinket 1"
      when 14 then "Trinket 2"
      when 15 then "Back"
      when 16 then "Main Hand"
      when 17 then "Off Hand"
      when 18 then "Ranged"
      when 19 then "Tabard"
      when 20 then "First Bag"
      when 21 then "Second Bag"
      when 22 then "Third Bag"
      when 23 then "Fourth Bag"
      else "None"
    end
  end
end