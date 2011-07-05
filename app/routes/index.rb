# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/" do
    @page = { :title => "wowbom: craft like a boss™" }
    erb :index
  end
end