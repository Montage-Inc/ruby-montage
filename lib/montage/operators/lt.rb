module Montage
  module Operators
    class Lt
      def self.operator
        "<"
      end

      def self.montage_operator
        "__lt"
      end

      def self.==(value)
        value =~ /[^=>]<[^=>]/i
      end
    end
  end
end
