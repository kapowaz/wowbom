# encoding: utf-8
class Wowbom < Sinatra::Application
  post "/" do
    results = Item.from_query(params[:query]).all(:recipe.not => nil, :order => [:quality_id.asc, :name.asc])
    
    if results.length == 1
      # redirect to that item
      redirect "/item/#{results.first.id}", 301
    elsif results.length > 1
      redirect "/search/#{uri_escape params[:query].downcase.strip}", 301
    else
      # TODO: error page 
      erb :notfound
    end
  end
  
  get "/search/:query" do |query|
    @query   = uri_unescape(query)
    @page    = { :title => "wowbom — searching for “#{@query}”" }
    @results = Item.from_query(@query).all(:recipe.not => nil, :order => [:quality_id.asc, :name.asc])
    erb :search
  end
end