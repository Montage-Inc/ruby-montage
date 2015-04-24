module Montage
  module Operators
    class Ilike
      def self.operator
        "ilike"
      end

      def self.montage_operator
        "__icontains"
      end

      def self.==(value)

      end
    end
  end
end