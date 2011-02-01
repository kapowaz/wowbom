require "sinatra"
require "open-uri"
require "nokogiri"
require "json"
require "merbhelpers"
require "helpers"

include MerbHelpers
include Helpers

get "/" do
  @page = { :title => "wowcrafter" }
  erb :index
end

post "/" do
  # TODO: optimise. This is all horrendously slow currently
  # due to the fact it performs two round-trips to wowhead's 
  # item XML for any single request, even before it looks up 
  # reagent prices
  
  recipe_from_id = recipe_by_id(params[:query])
  
  if recipe_from_id[:error].nil?
    redirect "/id/#{params[:query]}"
  else
    item_name = URI.escape(params[:query], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    recipe_from_name = recipe_by_id(item_id_from_name(params[:query]))
    if recipe_from_name[:error].nil?
      redirect "/item/#{item_name}"
      erb :notfound
    else
      # wasn't either an item ID or a direct name match; instead show a list of search results...
      erb :notfound
    end
  end
end

get "/realms" do
  erb :realms, :layout => false
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
  # TODO: implement item_id_from_name to make this work...
  # recipe = item_id_from_name(recipe_by_id(item_name))
  # if recipe[:error].nil?
  #   title = "wowcrafter — Recipe for #{recipe[:name]}"
  # end
  # @page = { :title => title, :recipe => recipe }
  erb :notfound
end

error 403 do
  @page = { :title => "Forbidden" }
  erb :forbidden
end

error 404 do;
  @page = { :title => "Not Found" }
  erb :notfound
end