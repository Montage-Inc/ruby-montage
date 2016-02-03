module Montage
  module Operators
    class Gte
      def self.operator
        ">="
      end

      def self.montage_operator
        "$gte"
      end

      def self.==(value)
        value =~ /[^<]>=[^<]/
      end
    end
  end
end
