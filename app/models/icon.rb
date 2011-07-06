class Icon
  include DataMapper::Resource

  property :id,             Integer, :key => true
  property :name,           String
 
  has n, :items
 
  # TODO: cache all icons using Amazon S3 or similar
  def url(opts={})
    opts[:size]   = 56 unless [18, 36, 56].include? opts[:size]
    opts[:region] = 'eu' unless ['eu', 'us', 'kr'].include? opts[:region]
    "http://#{opts[:region]}.media.blizzard.com/wow/icons/#{opts[:size]}/#{self.name.downcase}.jpg"
  end
 
end