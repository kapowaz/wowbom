# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/item/:item_id.json" do |item_id|
    content_type :json
    
    item  = Item.from_wowget(item_id)
    
    item_json = {
      :id                  => item.id,
      :name                => item.name,
      :icon_id             => item.icon.id,
      :icon_name           => item.icon.name,
      :icon_url            => item.icon.url,
      :level               => item.level,
      :required_level      => item.required_level,
      :soulbound           => item.soulbound,
      :quality_id          => item.quality_id,
      :quality             => item.quality,
      :inventory_slot      => item.inventory_slot,
      :inventory_slot_name => item.inventory_slot_name,
      :category            => item.category,
      :buy_price           => item.buy_price.to_i,
      :sell_price          => item.sell_price.to_i,
      :created_at          => item.created_at,
      :updated_at          => item.updated_at,
      :patch               => item.patch,
      :added_in            => item.added_in,
    }
    
    item_json.to_json
  end

  get "/item/:item_id" do |item_id|
    item  = Item.from_wowget(item_id)
    
    if item.nil?
      @page = { :title => "wowbom — item not found" }
      
      erb :index
    else
      @page    = { :title => "wowbom — #{item.name}" }
      @item    = item
      @price   = @item.recipe.nil? ? nil : @item.recipe.price(:realm => @realm, :faction => @faction)
      
      erb :item
    end
  end
  
end