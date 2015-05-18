module Montage
  module Operators
    class Intersects
      def self.operator
        "intersects"
      end

      def self.montage_operator
        "__intersects"
      end

      def self.==(value)
        value =~ /\bintersects\b(?=([^']*'[^']*')*[^']*$)/i
      end
    end
  end
end
