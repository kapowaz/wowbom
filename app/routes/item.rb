# encoding: utf-8
class Wowbom < Sinatra::Application
  # this should probably be done outside of the app
  get "/id/:item_id" do |item_id|
    redirect "/item/#{item_id}", 301
  end

  get "/item/:item_id" do |item_id|
    item = Item.from_wowget(item_id)
    
    unless item.nil?
      @page = { :title => "wowbom — #{item.name}" }
    else
      @page = { :title => "wowbom — item not found" }
    end
    
    erb :item
  end  
end