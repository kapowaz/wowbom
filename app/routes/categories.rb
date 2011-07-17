# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/categories.json" do

    categories = {}
    
    Wowget::Item::CATEGORIES.each_pair do |id, category|
      categories[id] = {:name => category[:name], :slug => category[:slug]}
      if Wowget::Item::SUBCATEGORIES[category[:name]]
        categories[id][:subcategories] = {}
        Wowget::Item::SUBCATEGORIES[category[:name]].each_pair do |sub_id, subcategory|
          categories[id][:subcategories][sub_id] = {:name => subcategory[:name], :slug => subcategory[:slug]}
        end
      end
    end
    
    jsonp = params.delete('jsonp')
    
    if jsonp
      content_type :js
      "var #{jsonp} = #{categories.to_json};"
    else
      content_type :json
      categories.to_json
    end
  end
  
  get "/inventory_slots.json" do
    content_type :json
    inventory_slots = []
    
    Wowget::Item::INVENTORY_SLOTS.each_pair do |id, inventory_slot|
      inventory_slots << {:name => inventory_slot[:name], :slug => inventory_slot[:slug]}
    end
    
    jsonp = params.delete('jsonp')
    
    if jsonp
      content_type :js
      "var #{jsonp} = #{inventory_slots.to_json};"
    else
      content_type :json
      inventory_slots.to_json
    end
    
  end
  
  get "/category/:category_id" do |category_id|
    @category_id = category_id
    @category    = Category.first(:slug => category_id)

    erb :category
  end
  
  get "/category/:category_id/:subcategory_id" do |category_id, subcategory_id|
    @category_id    = category_id
    @subcategory_id = subcategory_id    
    @category       = Category.first(:slug => category_id, :subcategory_slug => subcategory_id)
    
    erb :category
  end
end