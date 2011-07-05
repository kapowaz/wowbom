require 'wowecon'

module DataMapper
  class Property
    class Currency < Integer
      
      min 0 # a value of zero should only ever relate to vendors that won't buy a given item, i.e. a special case.
      max 9_999_999_999
      required true

      def bind
        model.class_eval { include Wowecon::CurrencyHelpers }
      end
      
    end
  end
end