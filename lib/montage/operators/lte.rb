module Montage
  module Operators
    class Lte
      def self.operator
        "<="
      end

      def self.montage_operator
        "$lte"
      end

      def self.==(value)
        value =~ /[^>]<=[^>]/i
      end
    end
  end
end
