class Category
  include DataMapper::Resource

  property :id,                Integer, :key => true
  property :subcategory_id,    Integer, :key => true
  property :name,              String
  property :subcategory_name,  String
  property :slug,              String
  property :subcategory_slug,  String

  has n, :items

  def self.populate_all!(options={})
    Wowget::Item::CATEGORIES.each_pair do |id, category|
      if Wowget::Item::SUBCATEGORIES[category[:name]]
        Wowget::Item::SUBCATEGORIES[category[:name]].each_pair do |sub_id, subcategory|
          existing = Category.first(:id => id, :subcategory_id => sub_id)
          if existing.nil?
            # new
            puts "Creating category id #{id}, subcategory id #{sub_id} (#{category[:name]} > #{subcategory[:name]} - /#{category[:slug]}/#{subcategory[:slug]})" if options[:debug]
            Category.create(
              :id               => id, 
              :subcategory_id   => sub_id, 
              :name             => category[:name], 
              :subcategory_name => subcategory[:name],
              :slug             => category[:slug],
              :subcategory_slug => subcategory[:slug])
          else
            # update
            puts "Updating category id #{id}, subcategory id #{sub_id} (#{category[:name]} > #{subcategory[:name]} - /#{category[:slug]}/#{subcategory[:slug]})" if options[:debug]
            existing.update(
              :name             => category[:name], 
              :subcategory_name => subcategory[:name],
              :slug             => category[:slug],
              :subcategory_slug => subcategory[:slug])
          end
        end
      else
        existing = Category.first(:id => id)
        if existing.nil?
          puts "Creating category id #{id} (#{category[:name]} - /#{category[:slug]})" if options[:debug]
          Category.create(:id => id, :name => category[:name], :slug => category[:slug])          
        else
          puts "Updating category id #{id} (#{category[:name]} - /#{category[:slug]})" if options[:debug]
          existing.update(:name => category[:name], :slug => category[:slug])
        end
      end
    end
  end
  
  def self.as_hash
    categories = {}
    Wowget::Item::CATEGORIES.each_pair do |id, category|
      categories[id] = {:name => category[:name], :slug => category[:slug]}
      if Wowget::Item::SUBCATEGORIES[category[:name]]
        categories[id][:subcategories] = {}
        Wowget::Item::SUBCATEGORIES[category[:name]].each_pair do |sub_id, subcategory|
          categories[id][:subcategories][sub_id] = {:name => subcategory[:name], :slug => subcategory[:slug]}
          categories[id][:subcategories][sub_id][:inventoryslots] = true if subcategory[:inventoryslots]
        end
      end
    end
    categories
  end

end