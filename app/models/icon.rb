class Icon
  include DataMapper::Resource

  property :id,             Integer, :key => true
  property :name,           String
 
  has n, :items
 
  # TODO: cache all icons using Amazon S3 or similar
  def url
    "http://eu.battle.net/wow-assets/static/images/icons/56/#{self.name.downcase}.jpg"
  end
 
end