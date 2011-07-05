# encoding: utf-8

require File.join(File.dirname(__FILE__), '../..', 'application.rb')

namespace :wowbom do
  desc "Fetch latest market price data from wowecon.com"
  task :prices do
    # TODO
  end
  
  desc "Generate item categories and sub-categories based on Wowget::Item"
  task :categories do
    Wowget::Item::CATEGORIES.each_pair do |id, name|
      if Wowget::Item::SUBCATEGORIES[name]
        Wowget::Item::SUBCATEGORIES[name].each_pair do |sub_id, subcategory_name|
          puts "Creating category id #{id}, subcategory id #{sub_id} (#{name} > #{subcategory_name})"
          Category.create(:id => id, :subcategory_id => sub_id, :name => name, :subcategory_name => subcategory_name)
        end
      else
        puts "Creating category id #{id} (#{name})"
        Category.create(:id => id, :name => name)
      end
    end
  end
  
  desc "Fetch all crafted items from wowhead.com"
  task :items do
    range = 40000..45000
    for item_id in range do
      Item.from_wowget(item_id, :debug => true)
    end
  end
  
  desc "Fetch all realms and statuses from battle.net"
  task :realms do
    regions = {:us => 'Americas & Oceania', :eu => 'European', :kr => 'South Korean'}
    regions.each_pair do |region, locale|
      puts "Fetching #{locale} realms…\n"
      realms = JSON.parse(open("http://#{region}.battle.net/api/wow/realm/status").read).first[1]
      
      unless realms.nil? || realms.length == 0
        Realm.all(:region => region.to_s).destroy
        realms.each do |realm|
          r = Realm.create(
            :status       => realm["status"],
            :slug         => realm["slug"],
            :population   => realm["population"],
            :type         => realm["type"],
            :queue        => realm["queue"],
            :name         => realm["name"],
            :region       => region.to_s,
            :locale       => locale
          )
          print "•".green unless r.errors.any?
        end
        print "\nFound #{realms.length} realms.\n\n"
      end  
    end
    
  end
end