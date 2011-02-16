class Currency
  attr_accessor :value
  
  def initialize (value)
    @value  = value
    f       = sprintf("%.4f", @value).split(".")
    @gold   = f[0].to_i
    @silver = f[1][0,2].to_i
    @copper = f[1][2,2].to_i
  end
  
  def denoms
    {:gold => @gold, :silver => @silver, :copper => @copper}
  end
  
  def denoms=(denoms)
    @value = (denoms[:gold] + (denoms[:silver].to_f / 100) + (denoms[:copper].to_f / 10000)).to_f
  end
  
  def tags
    coins = [{:gold => @gold}, {:silver => @silver}, {:copper => @copper}]
    tags  = ""
    coins.each do |coin|
      coin.each do |denom, value|
        if value > 0 || tags.length > 0
          tags += "<var class=\"#{denom.to_s}\">#{value.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")}</var>"
        end
      end
    end
    tags
  end
  
  def to_s
    coins  = [{:gold => @gold}, {:silver => @silver}, {:copper => @copper}]
    output = ""
    coins.each do |coin|
      coin.each do |denom, value|
        if value > 0 || output.length > 0
          output += "#{value.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")}#{denom.to_s[0,1]} "
        end
      end
    end
    output.strip
  end
end

# c = Currency.new(12345.6789)
# c.denoms => {:gold => 12345, :silver => 67, :copper => 89}
# c.tags => "<var class=\"gold\">12,345</var><var class=\"silver\">67</var><var class=\"copper\">89</var>"
# c.to_s => "12,345g 67s 89c"
# c.denoms = {:gold => 0, :silver => 67, :copper => 89}
# c.value = 0.6789
# c.tags => "<var class=\"silver\">67</var><var class=\"copper\">89</var>"
# c.to_s => "67s 89c"