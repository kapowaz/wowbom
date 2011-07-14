# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/item/:item_id.json" do |item_id|
    content_type :json
    
    Item.from_wowget(item_id).json(:realm => @realm, :faction => @faction).to_json
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