# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/recipe/:recipe_id.json" do |recipe_id|
    content_type :json
    
    recipe  = Recipe.from_wowget(recipe_id)
    
    recipe_json = {
      :id            => recipe.id,
      :name          => recipe.name,
      :profession    => recipe.profession,
      :profession_id => recipe.profession_id,
      :skill         => recipe.skill,
      :created_at    => recipe.created_at,
      :updated_at    => recipe.updated_at,
      :patch         => recipe.patch,
      :added_in      => recipe.added_in,
      # :price         => recipe.price(:realm => @alonsus, :faction => :alliance).to_i
      
    }
    
    recipe_json[:reagents] = []
    recipe.reagents.each do |reagent|
      recipe_json[:reagents] << {
        :component => reagent.component.id, 
        :quantity => reagent.quantity, 
        :buy_price => reagent.component.buy_price.to_i,
        :auction_price => reagent.component.price_for(:realm => @alonsus, :faction => :alliance).to_i
      }
    end
    
    recipe_json.to_json
  end
end