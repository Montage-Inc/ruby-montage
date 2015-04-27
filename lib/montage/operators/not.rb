module Montage
  module Operators
    class Not
      def self.operator
        " != "
      end

      def self.montage_operator
        "__not"
      end

      def self.==(value)

      end
    end
  end
end