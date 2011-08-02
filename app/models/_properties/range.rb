module DataMapper
  class Property
    class Range < String
      
      length 32
      required true
      
      # hack for now to address problems with the property system in dm-core - see 
      # see https://github.com/knowtheory/dm-chrome-history/blob/master/lib/dm-chrome-history/types/chrome_epoch_time.rb
      def custom?; true; end
      
      def load(value)
        return nil if value.nil?
        return value unless value.kind_of?(::String)
        r = value.split('..').map {|d| Integer(d) }
        r[0]..r[1]
      end
      
      def dump(value)
        return value.to_s unless value.nil?
      end
      
      alias_method :typecast_to_primitive, :load
      alias_method :typecast, :load
    end
  end
end