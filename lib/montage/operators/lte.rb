module Montage
  module Operators
    class Lte
      def self.operator
        " <= "
      end

      def self.montage_operator
        "__lte"
      end

      def self.==(value)

      end
    end
  end
end