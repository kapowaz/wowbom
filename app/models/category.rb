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
          puts "Creating category id #{id}, subcategory id #{sub_id} (#{category[:name]} > #{subcategory[:name]} - /#{category[:slug]}/#{subcategory[:slug]})" if options[:debug]
          Category.create(
            :id               => id, 
            :subcategory_id   => sub_id, 
            :name             => category[:name], 
            :subcategory_name => subcategory[:name],
            :slug             => category[:slug],
            :subcategory_slug => subcategory[:slug])
        end
      else
        puts "Creating category id #{id} (#{category[:name]} - /#{category[:slug]})" if options[:debug]
        Category.create(:id => id, :name => category[:name], :slug => category[:slug])
      end
    end
  end

end