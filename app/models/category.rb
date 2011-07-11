class Category
  include DataMapper::Resource

  property :id,                Integer, :key => true
  property :subcategory_id,    Integer, :key => true
  property :name,              String
  property :subcategory_name,  String

  has n, :items

  def self.populate_all!(options={})
    Wowget::Item::CATEGORIES.each_pair do |id, name|
      if Wowget::Item::SUBCATEGORIES[name]
        Wowget::Item::SUBCATEGORIES[name].each_pair do |sub_id, subcategory_name|
          puts "Creating category id #{id}, subcategory id #{sub_id} (#{name} > #{subcategory_name})" if options[:debug]
          Category.create(:id => id, :subcategory_id => sub_id, :name => name, :subcategory_name => subcategory_name)
        end
      else
        puts "Creating category id #{id} (#{name})" if options[:debug]
        Category.create(:id => id, :name => name)
      end
    end
  end

end