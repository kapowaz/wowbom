# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/login" do
    erb :login
  end
  
  get "/register" do
    erb :register
  end
end