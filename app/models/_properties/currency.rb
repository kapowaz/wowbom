require 'wowecon'

module DataMapper
  class Property
    class Currency < Integer
      min 0 # a value of zero should only ever relate to vendors that won't buy a given item, i.e. a special case.
      max 9_999_999_999
      required true
      
      # hack for now to address problems with the property system in dm-core - see 
      # see https://github.com/knowtheory/dm-chrome-history/blob/master/lib/dm-chrome-history/types/chrome_epoch_time.rb
      def custom?; true; end
      
      def load(value)
        return value unless value.respond_to?(:to_int)
        Wowecon::Currency.new(value)
      end
      
      def dump(value)
        value.to_i unless value.nil?
      end
      
      alias_method :typecast_to_primitive, :load
    end
  end
end