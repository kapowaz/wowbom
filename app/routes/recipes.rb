# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/recipe/:recipe_id.json" do |recipe_id|
    content_type :json
    
    Recipe.from_wowget(recipe_id).to_hash(:realm => @realm, :faction => @faction).to_json
  end
end