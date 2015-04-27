module Montage
  module Operators
    class In
      def self.operator
        " in "
      end

      def self.montage_operator
        "__in"
      end

      def self.==(value)

      end
    end
  end
end