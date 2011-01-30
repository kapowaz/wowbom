require "sinatra"
require "open-uri"
require "nokogiri"
require "helpers"

include Helpers

get "/" do
  @page = { :title => "WoWCrafter" }
  erb :index
end

error 403 do
  @page = { :title => "Forbidden" }
  erb :forbidden
end

error 404 do;
  @page = { :title => "Not Found" }
  erb :notfound
end