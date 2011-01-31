require "sinatra"
require "open-uri"
require "nokogiri"
require "merbhelpers"
require "helpers"

include MerbHelpers
include Helpers

get "/" do
  @page = { :title => "wowcrafter" }
  erb :index
end

get "/id/:item_id" do |item_id|
  recipe = recipe_by_id(item_id)
  if recipe[:error].nil?
    title = "wowcrafter — Recipe for #{recipe[:name]}"
  end
  @page = { :title => title, :recipe => recipe }
  erb :item
end

get "/item/:item_name" do |item_name|
  recipe = item_id_from_name(recipe_by_id(item_name))
  if recipe[:error].nil?
    title = "wowcrafter — Recipe for #{recipe[:name]}"
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