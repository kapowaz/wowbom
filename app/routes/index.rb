# encoding: utf-8
class Wowbom < Sinatra::Application
  before do
    unless Realm.any?
      Realm.update_all!
    end
    
    # TODO: use saved realm/faction settings here
    @page     = { :title => "wowbom: craft like a boss™" }
    @realm    = Realm.first(:slug => :alonsus, :region => :eu)
    @faction  = :alliance
    @category = nil # Category.first(:slug => 'armor')
  end
  
  get "/" do
    erb :index
  end
end