# encoding: utf-8
class Realm
  include DataMapper::Resource
  
  property :id,             Serial
  property :status,         Boolean
  property :slug,           String
  property :population,     String
  property :type,           String  
  property :queue,          Boolean
  property :name,           String
  property :region,         String
  property :locale,         String
  
  REGIONS = {
    :eu => "European", 
    :us => "Americas & Oceania", 
    :kr => "South Korean", 
    :tw => "Taiwanese"
  }
  
  def self.update_all!(options={})
    REGIONS.each_pair do |region, locale|
      updated, created = 0, 0
      
      realm_status = open("http://#{region}.battle.net/api/wow/realm/status")
      
      begin
        realms           = JSON.parse(realm_status.read).first[1]

        puts "Fetching #{locale} realms…\n" if options[:debug]

        unless realms.nil? || realms.length == 0
          realms.each do |realm|
            existing_realm = Realm.first(:slug => realm["slug"], :region => region)

            unless existing_realm.nil?
              existing_realm.attributes = {
                :status       => realm["status"],
                :population   => realm["population"],
                :type         => realm["type"],
                :queue        => realm["queue"],
              }
              existing_realm.save

              if options[:debug]
                print "•".green unless existing_realm.errors.any?            
              end

              updated += 1
            else
              new_realm = Realm.create(
                :status       => realm["status"],
                :slug         => realm["slug"],
                :population   => realm["population"],
                :type         => realm["type"],
                :queue        => realm["queue"],
                :name         => realm["name"],
                :region       => region.to_s,
                :locale       => locale
              )

              if options[:debug]
                print "+".green unless new_realm.errors.any?            
              end

              created += 1
            end
          end
          print "\nFound #{created} new realms and updated #{updated} existing realms.\n\n" if options[:debug]
        end
      rescue
        puts "Unable to access battle.net realm list for #{locale}."
      end

    end
  end
  
  def update_from_api(options={})
    realm = JSON.parse(open("http://#{self.region}.battle.net/api/wow/realm/status?realms=#{self.slug}").read).first[1][0]
    self.update({
      :status       => realm["status"],
      :population   => realm["population"],
      :type         => realm["type"],
      :queue        => realm["queue"],
    })
    self.saved?
  end

end