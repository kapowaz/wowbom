# encoding: utf-8
class Wowbom < Sinatra::Application
  # this should probably be done outside of the app
  get "/id/:item_id" do |item_id|
    redirect "/item/#{item_id}", 301
  end

  get "/item/:item_id" do |item_id|
    item  = Item.from_wowget(item_id)
    
    if item.nil?
      @page = { :title => "wowbom — item not found" }
      erb :index
    else
      @page    = { :title => "wowbom — #{item.name}" }
      @realm   = Realm.first(:slug => :alonsus)
      @faction = :alliance
      @item    = item
      erb :item
    end
  end  
end