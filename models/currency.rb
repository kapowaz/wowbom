module DataMapper
  class Property
    class Currency < Float
      required true
      
      attr_accessor :gold, :silver, :copper
      
      def self.from_hash(denoms)
        value = (denoms[:gold] + (denoms[:silver].to_f / 100) + (denoms[:copper].to_f / 10000)).to_f
      end
      
      def load(value)
        f       = sprintf("%.4f", value).split(".")
        @gold   = f[0].to_i
        @silver = f[1][0,2].to_i
        @copper = f[1][2,2].to_i
        value
      end
      
      def dump(value)
        value = ((@gold + @silver.to_f / 100) + (@copper.to_f / 10000)).to_f
        value
      end
      
      def to_hash
        {:gold => @gold, :silver => @silver, :copper => @copper}
      end
      
      def tags
        coins = [self.to_hash]
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
        coins  = [self.to_hash]
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
  end
end