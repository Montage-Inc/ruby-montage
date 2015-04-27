module Montage
  module Operators
    class Gte
      def self.operator
        " >= "
      end

      def self.montage_operator
        "__gte"
      end

      def self.==(value)

      end
    end
  end
end