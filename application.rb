require "sinatra"
require "helpers"

include Helpers

get "/" do
  @page = { :title => "wowcrafter" }
  erb :index
end

error 403 do
  @page = { :title => "Forbidden!" }
  erb :forbidden
end

error 404 do;
  @page = { :title => "Not Found!" }
  erb :notfound
end