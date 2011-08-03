# encoding: utf-8
class Wowbom < Sinatra::Base
  get "/item/:item_id.json" do |item_id|
    content_type :json
    
    Item.from_wowget(item_id).to_hash(:realm => @realm, :faction => @faction).to_json
  end

  # get "/item/?:item_id?/?:item_name?" do |item_id, item_name|
  get "/item/:item_id" do |item_id|
    item  = Item.from_wowget(item_id)
    
    unless item.nil?
      @page    = { :title => "wowbom — #{item.name}" }
      @item    = item
      @price   = @item.recipe.nil? ? nil : @item.recipe.price(:realm => @realm, :faction => @faction)
      erb :item
    else
      @page = { :title => "wowbom — item not found" }
      erb :index
    end
  end
  
end