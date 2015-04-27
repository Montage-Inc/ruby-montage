module Montage
  module Operators
    class Notin
      def self.operator
        " not in "
      end

      def self.montage_operator
        "__notin"
      end

      def self.==(value)

      end
    end
  end
end