# encoding: utf-8
class Wowbom < Sinatra::Application
  get "/category/:category_id" do |category_id|
    @category = Category.first(:id => category_id)
    erb :category
  end
  
  get "/category/:category_id/:subcategory_id" do |category_id, subcategory_id|
    @category = Category.first(:id => category_id, :subcategory_id => subcategory_id)
    erb :category
  end
end