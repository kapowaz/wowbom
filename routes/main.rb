require 'open-uri'
require 'nokogiri'

class WowBom < Sinatra::Application
  
  get "/" do
    @page = { :title => "wowbom: craft like a boss™", :environment => WowBom.environment() }
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
    redirect to("/item/#{item_id}"), 301
  end

  get "/item/:item_name" do |item_name|
    recipe = recipe_by_id(item_id)
    if recipe[:error].nil?
      title = "wowbom — #{recipe[:name]}"
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
  
end