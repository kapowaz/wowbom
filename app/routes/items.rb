# encoding: utf-8
class Wowbom < Sinatra::Application
  # this should probably be done outside of the app
  get "/id/:item_id" do |item_id|
    redirect "/items/#{item_id}", 301
  end

  get "/items/:item_id" do |item_id|
    item  = Item.from_wowget(item_id)
    
    if item.nil?
      @page = { :title => "wowbom — item not found" }
      
      erb :index
    else
      @page    = { :title => "wowbom — #{item.name}" }
      @realm   = Realm.first(:slug => :alonsus) # TODO: pull from stored setting
      @faction = :alliance # TODO: pull from stored setting
      @item    = item
      
      @price   = @item.price(:realm => @realm, :faction => @faction).first || nil
      
      erb :item
    end
  end
end