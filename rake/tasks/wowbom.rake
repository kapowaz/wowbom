namespace :wowbom do
  desc "Fetch latest market price data from wowecon.com"
  task :prices do
    # TODO
  end
  
  desc "Fetch all crafted items from wowhead.com"
  task :items do
    # TODO
  end
  
  desc "Fetch all realms and statuses from battle.net"
  task :realms do
    require 'open-uri'
    require_relative '../../models/init.rb'
    
    regions = {:us => 'Americas &amp; Oceania', :eu => 'European', :kr => 'South Korean'}
    regions.each_pair do |region, locale|
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
        end
      end  
    end
    
  end
end