# encoding: utf-8
require 'open-uri'
require 'nokogiri'

class WowBom < Sinatra::Application
  
  get "/" do
    @page = { :title => "wowbom: craft like a boss™" }
    erb :index
  end

  post "/" do
    # TODO: optimise. This is all horrendously slow currently
    # due to the fact it performs two round-trips to wowhead's 
    # item XML for any single request, even before it looks up 
    # reagent prices

    recipe_from_id = recipe_by_id(params[:query])

    if recipe_from_id[:error].nil?
      redirect "/item/#{params[:query]}"
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
  
  # this should probably be done outside of the app
  get "/id/:item_id" do |item_id|
    redirect "/item/#{item_id}", 301
  end

  get "/item/:item_id" do |item_id|
    item   = Wowget::Item.new(item_id)
    recipe = Wowget::Spell.new(item.recipe_id) unless item.recipe_id.nil?
    
    if item.error.nil?
      title = "wowbom — #{item.name}"
    end
    @page = { :title => title, :item => item, :recipe => recipe }
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
  
end