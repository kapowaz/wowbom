# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/categories.json" do
    jsonp = params.delete('jsonp')
    
    if jsonp
      content_type :js
      "var #{jsonp} = #{Category.as_hash.to_json};"
    else
      content_type :json
      Category.as_hash.to_json
    end
  end
  
  get "/inventory_slots.json" do
    jsonp = params.delete('jsonp')    
    if jsonp
      content_type :js
      "var #{jsonp} = #{Wowget::Item::INVENTORY_SLOTS.to_json};"
    else
      content_type :json
      Wowget::Item::INVENTORY_SLOTS.to_json
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
  
  get "/category/:category_id/:subcategory_id/:inventory_slot" do |category_id, subcategory_id, inventory_slot|
    @category_id    = category_id
    @subcategory_id = subcategory_id
    @inventory_slot = Wowget::Item.inventory_slot_from_slug(inventory_slot)
    @category       = Category.first(:slug => category_id, :subcategory_slug => subcategory_id)
    
    erb :category
  end
end