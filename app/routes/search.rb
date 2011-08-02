# encoding: utf-8
class Wowbom < Sinatra::Base
  post "/" do
    @query   = params[:query]
    @results = Item.from_query(@query).all(:recipe.not => nil, :order => [:quality_id.desc, :name.asc])
    
    if @results.length == 1
      redirect "/item/#{@results.first.id}", 301
    else
      redirect "/search/#{uri_escape @query.downcase.strip}", 301
    end
  end
  
  get "/search/:query" do |query|
    @query   = uri_unescape(query)
    @page    = { :title => "wowbom — searching for “#{@query}”" }
    @results = Item.from_query(@query).all(:recipe.not => nil, :order => [:quality_id.desc, :name.asc])
    erb :search
  end
end