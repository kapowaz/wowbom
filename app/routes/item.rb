# encoding: utf-8
class Wowbom < Sinatra::Application
  # this should probably be done outside of the app
  get "/id/:item_id" do |item_id|
    redirect "/item/#{item_id}", 301
  end

  get "/item/:item_id" do |item_id|
    if item.error.nil?
      title = "wowbom — #{item.name}"
    end
    @page = { :title => title, :item => item, :recipe => recipe }
    erb :item
  end  
end