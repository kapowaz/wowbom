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
  property :created_at,     DateTime
  property :updated_at,     DateTime
  
  belongs_to :icon
  belongs_to :category
  belongs_to :recipe, :required => false
  
  has n, :price
  
  validates_presence_of :name
  validates_numericality_of :level, :quality_id
  
  def self.from_wowget(item_id, options={})
    if Item.get(item_id).nil?
      wowget_item = Wowget::Item.new(item_id)

      if wowget_item.error.nil?
        
        if options[:debug]
          puts "Fetching item ##{item_id} #{wowget_item.to_link}"
        end
        
        recipe   = nil
        recipe   = Recipe.from_wowget(wowget_item.recipe_id, options) unless wowget_item.recipe_id.nil?
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
          :created_at     => now,
          :updated_at     => now,
          :icon           => icon,
          :category       => category
        )
        item.recipe = recipe unless recipe.nil?
        item.save
        item
      end
    else
      item = Item.get(item_id)
      now = Time.now()
      
      # if the listing is more than 28 days old...
      if now.to_i - item.updated_at.to_time.to_i > 2419200
        item.update_wowget
      else
        item
      end
    end
  end
  
  def update_wowget
    self
  end
  
  def quality
    [:poor, :common, :uncommon, :rare, :epic, :legendary, :artifact, :heirloom][self.quality_id].to_s.capitalize
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