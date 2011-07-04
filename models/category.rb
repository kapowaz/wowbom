class Category
 include DataMapper::Resource
 
 property :id,                Integer, :key => true
 property :subcategory_id,    Integer, :key => true
 property :name,              String
 property :subcategory_name,  String
 
 has n, :items
end