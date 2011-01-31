require "sinatra"
require "open-uri"
require "nokogiri"
require "helpers"

include Helpers

get "/" do
  @page = { :title => "WoWCrafter" }
  erb :index
end

get "/item/:item_id" do |item_id|
  recipe = recipe_by_id(item_id)
  if recipe[:error].nil?
    title = "WoWCrafter — Recipe for #{recipe[:name]}"
  end
  @page = { :title => title, :recipe => recipe }
  erb :item
end

error 403 do
  @page = { :title => "Forbidden" }
  erb :forbidden
end

error 404 do;
  @page = { :title => "Not Found" }
  erb :notfound
end