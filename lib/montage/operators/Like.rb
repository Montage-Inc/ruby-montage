module Montage
  module Operators
    class Like
      def self.operator
        "like"
      end

      def self.montage_operator
        "__contains"
      end

      def self.==(value)

      end
    end
  end
end