# encoding: utf-8

require File.join(File.dirname(__FILE__), '../..', 'application.rb')

namespace :wowbom do
  desc "Fetch latest market price data from wowecon.com"
  task :prices do
    
    # factions = [:alliance, :horde, :neutral]
    #     realms   = Realm.all
    #     
    #     for item_id in range do
    #       item = Wowget::Item.new(item_id)
    #       
    #       if @item.error.nil?
    #         puts "Fetching price data for #{item_id} #{item.to_link}"
    #         realms.each do |realm|
    #           print "#{realm[:name]}: "
    #           factions.each_with_index do |faction, faction_index|
    #             # http://data.wowecon.com/?type=price&item_name=Inferno%20Ink&server_name=Alonsus&region=EU&faction=A
    #             price    = Wowecon.price(item.name, :name => realm[:name], :region => realm[:region], :faction => faction[0].to_s)
    #             now      = Time.now()
    # 
    #             # Create a Price for each realm and faction for this item
    #             
    #             case faction
    #             when :alliance
    #               print "#{currency.to_s.blue} "
    #             when :horde
    #               print "#{currency.to_s.red} "
    #             when :neutral
    #               print "#{currency.to_s.yellow} "
    #             end
    #           end
    #           print "\n"
    #         end        
    #       end
    #     end
    
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
    range = 61981..61982    
    for item_id in range do
      Item.from_wowget(item_id)
      
      # output?
      
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
          @realm = Realm.new(
            :status       => realm["status"],
            :slug         => realm["slug"],
            :population   => realm["population"],
            :type         => realm["type"],
            :queue        => realm["queue"],
            :name         => realm["name"],
            :region       => region.to_s,
            :locale       => locale
          )
          @realm.save
          print "•".green
        end
        print "\nFound #{realms.length} realms.\n\n"
      end  
    end
    
  end
end