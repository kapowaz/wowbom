module DataMapper
  module Helpers
    module General
      def filter_nil!(hash)
        hash.each_pair {|key, value| hash.delete key if value.nil?}
      end
    end
  end
end