# encoding: utf-8
class Query
  include DataMapper::Resource
  
  property :text,           String,   :key => true
  property :created_at,     DateTime, :default => lambda {|r, p| Time.now }
  property :updated_at,     DateTime, :default => lambda {|r, p| Time.now } 
  property :patch,          Version,  :default => Wowbom::PATCH_VERSION
  
  def self.fresh?(text)
    query = Query.first :text => text.downcase
    query.nil? ? false : query.patch >= Wowbom::PATCH_VERSION
  end
  
  def self.refresh!(text)
    query = Query.first :text => text.downcase
    now   = Time.now

    unless query.nil?
      query.update :updated_at => now, :patch => Wowbom::PATCH_VERSION
    else
      Query.create :text => text.downcase
    end
  end
  
end