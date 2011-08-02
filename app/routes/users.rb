# encoding: utf-8
class Wowbom < Sinatra::Base
  get "/login" do
    erb :login
  end
  
  get "/register" do
    erb :register
  end
end