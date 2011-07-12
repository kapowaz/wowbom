# encoding: utf-8
class Wowbom < Sinatra::Application
  post "/" do
    
    # e.g. redirect => redirect "/item/#{item_id}", 301
    
    # process to find an item page
    
    
    # 1. try getting the item with Item.from_wowget
    # 2. if it can't be gotten that way, 
    
    
    ONE_RESULT = false
    if ONE_RESULT
      
    else
      @page  = { :title => "wowbom — searching for “#{params[:query]}”" }
      @query = params[:query]
      erb :results
    end
    
  end
end