require 'wowecon'

module DataMapper
  class Property
    class Currency < Float
      
      include Wowecon::CurrencyHelpers
      
      def initialize(model, name, options = {})
        @gold   = 0
        @silver = 0
        @copper = 0
        
        super(model, name, options)
      end
      
      def primitive?(value)
        value.kind_of?(Float)
      end

      def dump(value)
        ((@gold + @silver.to_f / 100) + (@copper.to_f / 10000)).to_f
      end
      
      def load(value)
        f       = sprintf("%.4f", value).split(".")
        @gold   = f[0].to_i
        @silver = f[1][0,2].to_i
        @copper = f[1][2,2].to_i
        value
      end
      
      def typecast_to_primitive(value)
        load(value)
      end
    end
  end
end