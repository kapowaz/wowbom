# encoding: utf-8
class Wowbom < Sinatra::Base
  before do
    unless Realm.any?
      Realm.update_all!
    end
    
    # TODO: use saved realm/faction settings here
    @page     = { :title => "wowbom: craft like a boss™" }
    @realm    = Realm.first(:slug => :alonsus, :region => :eu)
    @faction  = :alliance
    @category = Category.first(:slug => 'armor')
  end
  
  get "/" do
    erb :index
  end
end