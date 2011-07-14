# encoding: utf-8
class Wowbom < Sinatra::Application
  before do
    unless Realm.any?
      Realm.update_all!
    end
    
    # TODO: use saved realm/faction settings here
    @realm   = Realm.first(:slug => :alonsus)
    @faction = :alliance
  end
  
  get "/" do
    @page = { :title => "wowbom: craft like a boss™" }
    erb :index
  end
end